#
# A minimal example SNAP Connect 2.4 application. This example was
# deliberately kept simple, and so does not showcase the full power
# of Python or SNAP Connect 2.4. It enables RPC access via TCP/IP
# or via SNAP Engine (2.4 GHZ radio, etc.), and gives you control
# of the Linux processor's "B" LED and Push Button.
#

# Modified from Original Synapse Wireless UserMain.py example
# Modified by J.C. Woltz to include functions for:
#  node to check if pending commands to run
#  node to log the lm75a with correct calculations
#  E10gateway node to find mac address of snap connect
#

from Snap import snap
 
import logging, logging.handlers, datetime, time, codecs, os, math
import binascii
import sys
import sqlite3
import fcntl, socket, struct
#import MySQLdb
print sys.path

def getHwAddr(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    info = fcntl.ioctl(s.fileno(), 0x8927,  struct.pack('256s', ifname[:15]))
    return ''.join(['%02x:' % ord(char) for char in info[18:24]])[:-1]

#
#
# Example routines to control the "B" LED on the E10
# (The "A" LED is connected to the internal SNAP Engine inside the E10)
#
#

#
# Individual LED pin control (used internally)
#
def setGreenLed(value):
    os.system("echo "+str(value)+" >> /sys/class/leds/greenled/brightness")

def setRedLed(value):
    os.system("echo "+str(value)+" >> /sys/class/leds/redled/brightness")

#
# It's actually a tri-color LED (this will be the public API)
#
def setLedBOff():
    setGreenLed(0)
    setRedLed(0)
 
def setLedBGreen():
    setGreenLed(1)
    setRedLed(0)
 
def setLedBRed():
    setGreenLed(0)
    setRedLed(1)
 
def setLedBYellow():
    setGreenLed(1)
    setRedLed(1)

##############################################################################
# This is used to set the PCF2129A of the snarf-base boards

def setRFTime(nodeAddr):
    """Call with nodeAddr to set the time on that node"""
    Year = int(time.strftime('%y'))
    Month = int(time.strftime('%m'))
    Date = int(time.strftime('%d'))
    Hour = int(time.strftime('%H'))
    Minute = int(time.strftime('%M'))
    Second = int(time.strftime('%S'))
    DOW = int(time.strftime('%w'))
    
    com.rpc(nodeAddr, "writeClockTime", Year, Month, Date, DOW, Hour, Minute, Second)

    name = convertAddr(com.rpc_source_addr())
    name2 = convertAddr(nodeAddr)
    print name + " Called setRFTime() for " + name2

# This is used to multicast time to PCF2129A. The snappy code on the node 
# could be modified to use this format.

def setRFPCF2129Time():
    """Call to multicast set time on all nodes with PCF2129A RTC"""
    Year = int(time.strftime('%y'))
    Month = int(time.strftime('%m'))
    Date = int(time.strftime('%d'))
    Hour = int(time.strftime('%H'))
    Minute = int(time.strftime('%M'))
    Second = int(time.strftime('%S'))
    DOW = int(time.strftime('%w'))
    # This will multicast "writeClockTime" with the parameters
    com.mcastRpc(1, 3, "writeClockTime", Year, Month, Date, DOW, Hour, Minute, Second)
    # This is used to format the string for loggin purposes
    if (Month < 10):
        Month = str(0) + str(Month)
    if (Date < 10):
        Date = str(0) + str(Date)
    if (Hour < 10):
        Hour = str(0) + str(Hour)
    if (Minute < 10):
        Minute = str(0) + str(Minute)    
    if (Second < 10):
        Second = str(0) + str(Second)
    #eventString = str(displayDOW(DOW)) + " 20" + str(Years) + "." + str(Months) + "." + str(Days) + " " + str(Hours) + ":" +  str(Minutes) + ":" + str(Seconds)
    eventString = "20" + str(Year) + "." + str(Month) + "." + str(Date) + " " + str(Hour) + ":" +  str(Minute) + ":" + str(Second)
    print "2129A mcastRpc Called at: " + eventString + " From: " + str(convertAddr(com.rpc_source_addr()))

##############################################################################
# This function is called from the E10 gateway node to find the mac of the  
# snap connect.
def whereIsSnap(name, NetID, scriptName):
    com.rpc(com.rpc_source_addr(), "setSnapConnectAddr")
    mac = convertAddr(com.rpc_source_addr())
    if  name == None:
        name = mac
    eventString = name + ":" + mac + ": Looking for SC with " + scriptName + " from " + convertAddr(NetID)
    print eventString

# This function is used to verify SC and E10node have connectivity
# (correct serial speed)
def pingSnap():
    com.rpc(com.rpc_source_addr(), "pongSnap")
    name = convertAddr(com.rpc_source_addr())
    print name + " Called pingSnap()"

##############################################################################
# This take the raw output of the lm75a and converts to C and F
def lm75aRawCalc(name, raw):
    """ Converts the raw reading from a LM75A Temp Sensor """
    if name == None:
        name = convertAddr(com.rpc_source_addr())
    intraw = int(raw)
    #print intraw.bit_length()
    intC = intraw >> 5
    #float fC 
    tC = intC / 8.0
    print tC
    tF = calcCtoF(tC)
    eventString = str(name) + "," + str(tF) + "," + str(tC)
    print eventString
    #logToCSV(name, eventString) 
    return tC

# Same as above, but logs to file
def loglm75aRawCalc(name, raw):
    """ Converts the raw reading from a LM75A Temp Sensor """
    mac = convertAddr(com.rpc_source_addr())
    if name == None:
        name = mac
    intraw = int(raw)
    intC = intraw >> 5
    tC = intC / 8.0
    tF = calcCtoF(tC)
    eventString = str(tC) + "," + str(tF) + "," + name
    #print eventString
    #formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + convertAddr(com.rpc_source_addr()) + "," + name + "," + eventString
    formattedString = time.strftime("%s") + "," + time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + mac + "," + eventString
    print formattedString
    f = open('/root/lm75alog.txt', 'a')
    f.write(formattedString + '\n')
    f.close()
    return tC
##############################################################################
# intenal function to convert C to F
def calcCtoF(raw):
    fraw = float(raw)
    tempF = (fraw * 9)/5 + 32
    #print tempF
    return tempF
##############################################################################
# Generic log to CSV
def logToCSV(name, logInfo):
    """Call with Node name and loginfo to log to file"""
    if name == None:
        name = convertAddr(com.rpc_source_addr())
    toLog = logInfo.split(',EOB')
    #formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + name + "," + toLog[0]
    #formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + convertAddr(com.rpc_source_addr()) + "," + name + "," + logInfo
    formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + convertAddr(com.rpc_source_addr()) + "," + name + "," + toLog[0]
    print formattedString
    f = open('/root/snap-csv.txt', 'a')
    f.write(formattedString + '\n')
    f.close()
    #rpc(remoteAddr, "tACKl", 1)

# Same as above, except logs in UNIX time.

def logToCSVU(name, logInfo):
    """Call with Node name and loginfo to log to file, time in unix format"""
    if name == None:
        name = convertAddr(com.rpc_source_addr())
    toLog = logInfo.split(',EOB')
    #formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + name + "," + toLog[0]
    #formattedString = time.strftime("%m/%d/%Y %I:%M:%S %p") + "," + convertAddr(com.rpc_source_addr()) + "," + name + "," + logInfo
    formattedString = time.strftime("%s") + "," + convertAddr(com.rpc_source_addr()) + "," + name + "," + toLog[0]
    print formattedString
    f = open('/root/snap-csvu.txt', 'a')
    f.write(formattedString + '\n')
    f.close()
    #rpc(remoteAddr, "tACKl", 1)
##############################################################################
# Unfinished to log to SQLite3
def logToSQL(name, loginfo):
    mac = convertAddr(com.rpc_source_addr())
    print "logToSQL called from: " + name + "," + mac + ": " + loginfo
    con = sqlite3.connect('/root/dc.sqlite')
    with con:
        cur = con.cursor()
        cur.execute("INSERT INTO snapLogs (NodeMAC, name, loginfo) VALUES (?,?,?)", (mac, name, loginfo))

def getcmdSQL():
    mac = str(convertAddr(com.rpc_source_addr()))
    print "getcmdSQL called from: " + mac + "!!!"
    con = sqlite3.connect('/root/dc.sqlite')

    with con:
        cur = con.cursor()
        print "Running Select..."
        cur.execute('SELECT * FROM RunMe WHERE NodeMAC=:NM and ACTIVE=1',{"NM": mac})
        print "Select done"
        #con.commit()

        rows = cur.fetchall()
        
        for row in rows:
            #print "Printing row: " + *row[0:]
            #linefields = row[2].decode(encoding='UTF-8',errors='strict').split(',')
            linefields = str(row[2]).split(',')
            #print "Linefileds : " + linefields
            #print "slinufields: " + str(linefields)
            com.rpc(com.rpc_source_addr(), *linefields[0:])
            #dtRun = time.strftime("%m/%d/%Y %I:%M:%S %p")
            formattedTime = time.strftime("%Y-%m-%d %H:%M:%S")
            id = str(row[0])
            if (str(row[6]) == '0'):
                cur.execute('UPDATE RunMe SET dtRun=?,active=0 WHERE id=?', (formattedTime,id))
            else:            
                cur.execute('UPDATE RunMe SET dtRun=? WHERE id=?', (formattedTime,id))

            eventString = str(row[0]) + " sent: " + str(row[2])
            cur.execute('INSERT INTO snapLogs (NodeMac, name, loginfo) VALUES (?,?,?)', (mac, mac, eventString))
            con.commit()
            print row[0]

def convertAddr(addr):
    """Converts binary address string to a more readable hex-ASCII address string"""
    return binascii.hexlify(addr)
##############################################################################
# Read a file. If file contains mac address and command, send rpc to calling 
# node based on file
def getcmd2x():
    f_cmds = open('/root/cmds2x.txt')
    wholn = convertAddr(com.rpc_source_addr())
    #eventString = str(convertAddr(remoteAddr))
    for line in f_cmds.readlines():
        linefields = line.strip().split(',')
        if (linefields[0] == wholn):
            print linefields
            com.rpc(com.rpc_source_addr(), *linefields[1:])
    f_cmds.close()

def sc_opened(arg1):
    setLedBGreen()
    print arg1
def sc_closed(arg1):
    setLedBRed()
    print arg1
def ser_closed(arg1,arg2):
    setLedBYellow()
    print "Serial Closed: ",
    print arg1,
    print arg2


#
# Example routine to read the MODE push button
# Normally a pullup resistor holds the pin high/True
# Pushing the button connects the physical pin to ground (low/False)
#
def readButton():
    result = os.system("/usr/bin/gpio9260 ?PB10")
    return result != 0 # Forcing boolean result


def server_auth(realm, username):
    """
    An example server authentication function
 
    Returns the password for the specified username in the realm
 
    realm : This server's realm
    username : The username specified by the remote server
    """
    if username == "public":
        return "public"
 
 
if __name__ == '__main__':
    import logging
    #setLedBYellow() 
    logging.basicConfig(filename='/root/sc.log',level=logging.DEBUG, format='%(asctime)s:%(msecs)03d %(levelname)-8s %(name)-8s %(message)s', datefmt='%H:%M:%S')
 
    funcdir = { # You CHOOSE what you want to provide RPC access to...
               'setLedBOff'       : setLedBOff,
               'setLedBGreen'     : setLedBGreen,
               'setLedBRed'       : setLedBRed,
               'setLedBYellow'    : setLedBYellow,
               'setRFTime'        : setRFTime,
               'getcmd2x'         : getcmd2x,
               'pingSnap'         : pingSnap,
               'loglm75aRawCalc'  : loglm75aRawCalc,
               'lm75aRawCalc'     : lm75aRawCalc,
               'setRFPCF2129Time' : setRFPCF2129Time,
               'logToCSV'         : logToCSV,
               'logToSQL'         : logToSQL,
               'whereIsSnap'      : whereIsSnap,
               'getcmdSQL'         : getcmdSQL
              }
    com = snap.SNAPcom(funcs=funcdir)

    # Make us accessible over TCP/IP
    com.accept_tcp(server_auth)

    # Make us accessible over our internal SNAP Engine
    #if (getHwAddr('eth0') == '00:1c:2c:34:43:de'):
    #    com.open_serial(1, '/dev/ttyUSB0')
    #else:
    #    com.open_serial(1, '/dev/ttyS1')
    com.open_serial(1, '/dev/ttyS1')
        

    #
    # Configure some example settings
    #

    # No encryption
    com.save_nv_param(snap.NV_AES128_ENABLE_ID, False)

    # Lock down our routes (we are a stationary device)
    com.save_nv_param(snap.NV_MESH_ROUTE_AGE_MAX_TIMEOUT_ID, 0)

    # Don't allow others to change our NV Parameters
    com.save_nv_param(snap.NV_LOCKDOWN_FLAGS_ID, 0x2)
 
    # Set hook to use led to inidicate stats
    #com.set_hook(HOOK_RPC_SENT, callback=None)
    #com.set_hook('HOOK_SNAPCOM_OPENED', callback=sc_opened)
    #com.set_hook('HOOK_SNAPCOM_CLOSED', callback=sc_closed)
    #com.set_hook(HOOK_TRACEROUTE, callback=None)
    #com.set_hook('HOOK_SERIAL_CLOSE', callback=ser_closed)

    # Run SNAP Connect until shutdown
    while True:
        com.poll()
    com.stop_accepting_tcp()

