# import necessary libraries and functions
from database import *
from flask import Flask, jsonify, request, redirect, render_template, url_for, flash, session
import jinja2
import time
from encrypt import *
# creating a Flask app
app = Flask(__name__)
app.secret_key = "apna_key"

train_list = []
pass_list = []
ticket_list = []


@app.route('/search',methods=['GET','POST'])
def search_train_page():
    if request.method == 'POST': 
        source = request.form.get("source-station")
        destination = request.form.get("destination-station")
        date = request.form.get("dateOfJourney")
        ls = searchTrain(source,destination,date)
        train_list.clear()
        for ele in ls:
            seats = getAvailableSeats(ele["train_no"], ele["date"])
            if seats <= 0:
                continue
            ele["seats"] = seats
            train_list.append(ele)
        return redirect("/result")
    return render_template("search_train.html")

@app.route('/result',methods=['GET','POST'])
def display_train_result():
    if request.method == 'POST':
        train_no = request.form.get("train_no")
        from_stat = request.form.get("from_stat")
        to_stat = request.form.get("to_stat")
        departure_t = request.form.get("departure_t")
        arrival_t = request.form.get("arrival_t")
        date = request.form.get("date")
        pass_list.clear()
        pass_list.append(train_no)
        pass_list.append(from_stat)
        pass_list.append(to_stat)
        pass_list.append(departure_t)
        pass_list.append(arrival_t)
        pass_list.append(date)
        return redirect("/passenger")
    return render_template("result.html",tr_list=train_list)



@app.route('/passenger',methods=['GET','POST'])
def input_passenger_detail():
    if request.method == 'POST':
        data = request.form.listvalues()
        ticket_list.clear()
        for ele in data:
            ticket_list.append(ele[0])
        curr_user = session["user"]
        pnr, seat_no = bookTicket(ticket_list, curr_user)
        ticket_list.append(pnr)
        ticket_list.append(seat_no)
        return redirect('/ticket')
    return render_template('Passenger_details.html',pass_d=pass_list)

@app.route('/ticket',methods=['GET','POST'])
def show_ticket_details():
    if request.method == 'POST':
        return redirect('/search')
    return render_template('ticket.html',ticket_list=ticket_list)


@app.route('/',methods=['GET','POST'])
def user_login_page():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        flag = checkUser(email, password)
        if flag == True:
            session["user"] = email
            if email =='admin123@gmail.com' and password == 'godpassword':
                return redirect('/admin') 
            return redirect('/search')
        else:
            msg = 'INVALID CREDENTIALS'
            url = '/'
            return show_error_page(msg,url)
    return render_template('login.html')


@app.route('/register',methods=['GET','POST'])
def user_register_page():
    if request.method == 'POST':
        name  = request.form.get('name')
        email  = request.form.get('email')
        phone_number  = request.form.get('number')
        age  = request.form.get('age')
        gender = request.form.get('gender')
        address = request.form.get('address')
        password_1 = request.form.get('password_1')
        password_2 = request.form.get('password_2')
        if password_1 != password_2:
            msg = 'PASSWORD ARE NOT SAME'
            url = '/register'
            return show_error_page(msg,url)
        user_detail = [name,email,password_1,age,gender,phone_number,email,address]
        flag = addUser(user_detail)
        if flag == False:
            msg = 'USER ALREADY EXIST'
            url = '/register'
            return show_error_page(msg,url)
        return redirect('/')
    return render_template('registration.html')

@app.route('/error')
def show_error_page(msg,url):
    print(msg)
    print(url)
    return render_template('error.html',msg=msg,url=url)



@app.route('/admin',methods=['GET','POST'])
def admin_home_page():
    return render_template('admin.html')

@app.route('/admin/create',methods=['GET','POST'])
def admin_create_train():
    if request.method == 'POST':
        train_no = request.form.get('train_no')
        seats = request.form.get('seats')
        day = request.form.get('day')
        train_details = [train_no,seats,day]
        flag = createTrain(train_details)
        if flag == False:
            msg = 'TRAIN NUMBER ALREADY TAKEN'
            url = '/admin/create'
            return show_error_page(msg,url)
        session["train_no"] = train_no
        return redirect('/admin/addstation')
    return render_template('create.html')

@app.route('/admin/addstation', methods=['GET','POST'])
def admin_add_station():
    if request.method == 'POST':
        train_no = request.form.get('train_no')
        source = request.form.get('source')
        source_at = request.form.get('source_at')
        source_dt = request.form.get('source_dt')
        destination = request.form.get('destination')
        destination_at = request.form.get('destination_at')
        destination_dt = request.form.get('destination_dt')
        trip = [train_no, source, source_at, source_dt,destination,destination_at,destination_dt]
        flag = addStation(trip)
        if flag == False:
            msg = 'INVALID TRAIN NUMBER'
            url = '/admin/addstation'
            return show_error_page(msg,url)
    add_train_no = session.get("train_no")
    if add_train_no == None:
        add_train_no = ""
    # print("\n\n\nvalue in addstation:" + add_train_no)
    return render_template('add_station.html', add_train_no=add_train_no)

@app.route('/admin/delete',methods=['GET','POST'])
def admin_delete_train():
    if request.method == 'POST':
        train_no = request.form.get('train_no')
        delete_train_no = [train_no]
        flag = deleteTrain(delete_train_no)
        if flag == False:
            msg = 'TRAIN NUMBER DOES NOT EXIST'
            url = '/admin'
            return show_error_page(msg,url)
        return redirect('/admin/delete')

    return render_template('delete.html')


@app.route('/admin/update',methods=['GET','POST'])
def admin_update_train():
    if request.method == 'POST':
        train_no = request.form.get('train_no')
        seats = request.form.get('seats')
        day = request.form.get('day')
        l = [train_no,seats,day]
        updateSeatsAndWeekdays(l)
        return redirect('/admin/update')
    return render_template('update.html')

@app.route('/admin/read')
def admin_read_page():
    return render_template('read.html')

@app.route('/admin/read/trains')
def admin_read_trains():

    trains = getTrains()
    return render_template('read_trains.html', tr_list = trains)

@app.route('/admin/read/stations')
def admin_read_stations():

    stations = getStations()
    return render_template('read_stations.html', stations_list = stations)

@app.route('/admin/read/tickets')
def admin_read_tickets():

    tickets = getTickets()
    return render_template('read_tickets.html', tickets_list = tickets)

@app.route('/admin/read/users',methods=['GET','POST'])
def admin_read_users():

    users = getUsers()
    return render_template('read_users.html', users_list = users)


# driver function
if __name__ == '__main__':
    app.run(debug = True, host = '0.0.0.0', port = 80)

