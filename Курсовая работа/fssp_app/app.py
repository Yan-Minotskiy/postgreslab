from flask import Flask, render_template, url_for
from flask_sqlalchemy import SQLAlchemy
import psycopg2

app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://'

def request(text, *vars):
    c  = psycopg2.connect(dbname='fssp', user='postgres', password='123', host='localhost').cursor()
    c.execute(text, (vars))
    return c.fetchall()[0]

class Address:
    def __init__(line):
        self.id = line[0]
        self, area, self.cuntry = request('SELECT area.name, country.name FROM area WHERE area=%s INNER JOIN country ON country.country_id=area.country', line[1])
        self.town = line[2]
        self.street = line[3]
        # TODO: добавить условие на null
        self.house = line[4]
        self.corpus = line[5]
        self.flat = line[6]
        self.print_text = self.country, + ', ' + self.area + ', ул. ' + self.street + ', д.' + self.house + self.corpus + ', кв. ' + self.flat


class Person:
    def __init__(line):
        self.id = line[0]
        self.name = line[1]
        self.surname = line[2]
        self.father_name = line[3]
        self.born_date = line[4]
        self.address = request('SELECT * FROM address WHERE address_id=', line[5])
        self.regisration = line[6]
       

        
cursor  = psycopg2.connect(dbname='fssp', user='postgres', password='123', host='localhost').cursor()
cursor.execute('SELECT * FROM person')
res = cursor.fetchall()[0][8]
print(res)

@app.route('/')
@app.route('/debtors')
def index():
    return render_template('eps.html')

@app.route('/auth')
def auth():
    return render_template('auth.html')

if __name__ == '__main__':
    app.run(debug=True)

# 