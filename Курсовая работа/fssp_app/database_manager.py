import psycopg2

conn = psycopg2.connect(dbname='fssp', user='postgres', password='123', host='localhost')
cursor  = conn.cursor()

def request(sql, *var, count_output=1,):
    cursor.execute(sql, (var))
    if count_output == 1:
        return cursor.fetchone()
    else:
        return cursor.fetchall()

class Address:
    def __init__(self, t):
        self.id = t[0]
        self.area = request('SELECT name FROM admin.area WHERE area_id=%s', str(t[1]))[0]
        self.country = request('SELECT country.name FROM admin.country' 
                               ' INNER JOIN admin.area ON area.country=country.country_id'
                               ' WHERE admin.area.area_id=%s', str(t[1]))[0]
        self.fulladdress = ', '.join([self.country, self.area, str(t[2]), str(t[3]), str(t[4])])
        if t[5] is not None:
            self.fulladdress += ', корп. ' + str(t[5])
        if t[6] is not None:
            self.fulladdress += ', кв. ' + str(t[6])

class Person:
    def __init__(self, t):
        self.id = t[0]
        self.fullname = t[2] + ' ' + t[1] + ' ' + t[3]
        self.born_date = str(t[4].day).zfill(2) + '.' + str(t[4].month).zfill(2) + '.' + str(t[4].year)
        self.address = Address(request('SELECT * FROM address WHERE address_id=%s', t[5])).fulladdress
        self.regisration = Address(request('SELECT * FROM address WHERE address_id=%s', t[6])).fulladdress
        if self.address == self.regisration or self.regisration == '':
            self.regisration = 'по месту проживания'
        self.phone = t[7]
        self.email = t[8]
        self.number_pasport = t[9][0:4] + ' ' + t[9][4:]
        self.date_issue = str(t[10].day).zfill(2) + '.' + str(t[10].month).zfill(2) + '.' + str(t[10].year)
        self.department_code = str(t[11]).zfill(6)
        self.born_place = Address(request('SELECT * FROM address WHERE address_id=%s', t[12])).fulladdress

listperson = [Person(p) for p in request('SELECT * FROM person', count_output=5)]

class EnforchmentProceeding:
    def __init__(self, t):
        self.number = t[0]
        self.court = request('SELECT * FROM court WHERE court_id=%s', t[1])
        self.responsible = request('SELECT * FROM workers WHERE workers_id=%s', t[2])
        self.payment_account = str(t[3]).zfill(10)
        self.recoverer = Person(request('SELECT * FROM person WHERE person_id=%s', t[4])).fullname
        self.debtor = Person(request('SELECT * FROM person WHERE person_id=%s', t[5])).fullname
        self.debt = t[6]
        self.start_date = str(t[7].day).zfill(2) + '.' + str(t[7].month).zfill(2) + '.' + str(t[7].year)

listenforchmentproceeding = [EnforchmentProceeding(p) for p in request('SELECT * FROM enforcement_proceeding', count_output=5)]

class Worker:
    pass