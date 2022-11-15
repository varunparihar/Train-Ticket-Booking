import mysql.connector as sql
from encrypt import *
import datetime

db = sql.connect(
  host = "localhost",
  user = "admin",
  password = "admin123",
  database = "railway"
)

def getAll():
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM USER")
    table = cursor.fetchall()
    result = []
    for row in table:
        result.append(row)
    return result

def getWhere(uid):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM USER WHERE user_id = %s", (uid,))
    table = cursor.fetchall()
    result = []
    for row in table:
        result.append(row)
    return result

def checkUser(uid, passwd):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM USER WHERE user_id = %s", (uid,))
    table = cursor.fetchall()
    if not table:
        return False
    password = table[0]["user_password"]
    if password == passwd:
        return True
    return False

def getWeekDay(date_str):
    format = '%Y-%m-%d'
    weekday = datetime.datetime.strptime(date_str, format)
    weekDayNumber = weekday.strftime('%w')
    return weekDayNumber

def getAvailableSeats(train_no, date):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT seat FROM AVAILABLE WHERE train_no = %s", (train_no,))
    row = cursor.fetchone()
    total_seats = row['seat']
    cursor.execute("SELECT count(*) as p FROM TICKET WHERE train_no = %s and d_date = %s", (train_no, date,))
    row = cursor.fetchone()
    booked_seats = row['p']
    availableSeats = total_seats - booked_seats
    return availableSeats

def searchTrain(from_code, to_code, date_s):
    from_code.upper()
    to_code.upper()
    weekday = getWeekDay(date_s)
    wdn = "%" + str(weekday) + "%"
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT a.train_no, a.station_code as from_stat, b.station_code as to_stat,a.departure_t, b.arrival_t, %s as date from STATION as a, STATION as b, AVAILABLE as c where a.train_no=b.train_no and a.station_code=%s and b.station_code=%s and a.mode = 0 and b.mode = 1 and c.train_no = a.train_no and c.week_day like %s", (date_s, from_code, to_code, wdn,))
    table = cursor.fetchall()
    result = []
    for row in table:
        result.append(row)
    return result

def bookTicket(d, curr_user):
    cursor = db.cursor(dictionary = True)
    train_no = d[0]
    date = d[5]
    cursor.execute("SELECT count(*) as p FROM TICKET where train_no=%s and d_date=%s", (train_no, date,))
    row = cursor.fetchone()
    seat_no = row['p']
    seat_no += 1
    cursor.execute("INSERT INTO TICKET(from_code,to_code,d_date,passenger_name,seat_no,train_no,user_id) VALUES(%s, %s, %s, %s, %s, %s, %s)", (d[1],d[2],d[5],d[6],seat_no,d[0],curr_user,))
    db.commit()
    cursor.execute("SELECT MAX(pnr) as p FROM TICKET")
    row = cursor.fetchone()
    pnr = row['p']
    return pnr,seat_no

def addUser(l):
    cursor = db.cursor(dictionary = True)
    try:
        cursor.execute("INSERT INTO USER VALUES(%s,%s,%s,%s,%s,%s,%s,%s)", (l[0],l[1],l[2],l[3],l[4],l[5],l[6],l[7],))
        db.commit()
    except sql.IntegrityError as err:
        return False
    return True

def createTrain(l):
    cursor = db.cursor(dictionary = True)
    try:
        cursor.execute("INSERT INTO AVAILABLE VALUES(%s, %s, %s)", (l[0],l[2],l[1],))
        db.commit()
    except sql.IntegrityError as err:
        return False
    return True

def addStation(l):
    cursor = db.cursor(dictionary = True)
    try:
        cursor.execute("INSERT INTO STATION VALUES(%s, %s, %s, %s, 0)", (l[1], l[0], l[2], l[3],))
        cursor.execute("INSERT INTO STATION VALUES(%s, %s, %s, %s, 1)", (l[4], l[0], l[5], l[6],))
        db.commit();
    except sql.IntegrityError as err:
        return False
    return True

def deleteTrain(l):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM STATION WHERE train_no =%s", (l[0],))
    table = cursor.fetchall()
    if len(table) == 0:
        return False
    cursor.execute("DELETE FROM AVAILABLE WHERE train_no = %s", (l[0],))
    db.commit()
    return True

def getTrainDetails(train_no):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM AVAILABLE WHERE train_no =%s", (train_no,))
    row = cursor.fetchone()
    if row == None:
        return []
    l = [row["seat"], row["week_day"]]
    print(l)
    return l

def updateSeatsAndWeekdays(l):
    cursor = db.cursor(dictionary = True)
    cursor.execute("UPDATE AVAILABLE SET seat = %s WHERE train_no =%s", (l[1],l[0],))
    cursor.execute("UPDATE AVAILABLE SET week_day = %s WHERE train_no =%s", (l[2],l[0],))
    db.commit()

def getStations(train_no):
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM STATION WHERE train_no =%s", (train_no,))
    table = cursor.fetchall()
    l = []
    for row in table:
        tmp = [row["station_code"], row["train_no"], row["arrival_t"], row["departure_t"]]
        l.append(tmp)
    return l

def updateTrainStations(l):
    pass

def getTrains():
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM AVAILABLE")
    table = cursor.fetchall()
    l = []
    for row in table:
        tmp = [row["train_no"], row["week_day"], row["seat"]]
        l.append(tmp)
    return l

def getStations():
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM STATION")
    table = cursor.fetchall()
    l = []
    for row in table:
        tmp = [row["station_code"], row["train_no"], row["arrival_t"], row["departure_t"], row["mode"]]
        l.append(tmp)

    return l


def getTickets():
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM TICKET")
    table = cursor.fetchall()
    l = []
    for row in table:
        tmp = [row["pnr"], row["from_code"], row["to_code"], row["d_date"], row["passenger_name"], row["seat_no"], row["train_no"], row["user_id"]]
        l.append(tmp) 
    return l

def getUsers():
    cursor = db.cursor(dictionary = True)
    cursor.execute("SELECT * FROM USER")
    table = cursor.fetchall()
    l = []
    for row in table:
        tmp = [row["user_name"], row["user_id"], row["user_password"], row["age"], row["gender"], row["phone_no"], row["emailid"], row["address"]]
        l.append(tmp)
    return l
