import psycopg2

conn = psycopg2.connect(dbname='fssp', user='postgres', password='123', host='localhost')
cursor  = conn.cursor()

def request(sql, *var, count_output=1,):
    cursor.execute(sql, (var))
    if count_output == 1:
        return cursor.fetchone()
    else:
        return cursor.fetchall()

def auth(login, password):
    try:
        return (
            request('SELECT login FROM workers WHERE login=%s', login)
            is not None
            and request(
                'SELECT * FROM workers WHERE password = crypt(%s, password)',
                password,
            )
            is not None
        )

    except:
        print('kjjk')
        return False

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
        self.ep_list = [i[0] for i in request('SELECT enforcement_proceeding_id FROM enforcement_proceeding WHERE debtor=%s', self.id, count_output=5)]
        self.ep_debt = []
        for ep in self.ep_list:
            self.ep_debt.append(request('SELECT check_dept(%s)', ep)[0])
        self.debt = sum(self.ep_debt)
        self.payment_list = []
        self.payment_amount = []
        self.timestamp_pay = []
        if self.ep_list != []:
            for ep in self.ep_list:
                self.payment_list.append(request('SELECT id FROM payment WHERE enforcement_proceeding=%s', ep)[0])
                self.payment_amount.append(request('SELECT amount FROM payment WHERE enforcement_proceeding=%s', ep)[0])
                self.timestamp_pay.append(request('SELECT timest FROM payment WHERE enforcement_proceeding=%s', ep)[0])
        self.len_payment_list = len(self.payment_list)


def sort_persons(person):
    return person.fullname

listperson = [Person(p) for p in request('SELECT * FROM person', count_output=5)]
listperson.sort(key=sort_persons)


class EnforchmentProceeding:
    def __init__(self, t):
        self.number = t[0]
        self.court = request('SELECT * FROM court WHERE court_id=%s', t[1])
        self.responsible_id = request('SELECT * FROM workers WHERE workers_id=%s', t[2])[0]
        self.responsible = ' '.join(request('SELECT surname, name, father_name FROM workers WHERE workers_id=%s', t[2]))
        self.payment_account = str(t[3]).zfill(10)
        self.recoverer = Person(request('SELECT * FROM person WHERE person_id=%s', t[4]))
        self.debtor = Person(request('SELECT * FROM person WHERE person_id=%s', t[5]))
        self.debt = t[6]
        self.start_date = str(t[7].day).zfill(2) + '.' + str(t[7].month).zfill(2) + '.' + str(t[7].year)
        self.now_debt = request('SELECT check_dept(%s)', self.number)[0]

listenforchmentproceeding = [EnforchmentProceeding(p) for p in request('SELECT * FROM enforcement_proceeding', count_output=5)]

class Worker:
    def __init__(self, t):
        self.id = t[0]
        self.fullname = t[2] + ' ' + t[1] + ' ' + t[3]
        self.department = request('SELECT name FROM department WHERE department_id=%s', t[4])[0]
        self.department_id = request('SELECT department_id FROM department WHERE department_id=%s', t[4])[0]
        self.post = request('SELECT name FROM admin.post WHERE post_id=%s', t[5])[0]
        self.post_id = request('SELECT post_id FROM admin.post WHERE post_id=%s', t[5])[0]
        self.login = t[6]
        self.eps = [ep for ep in listenforchmentproceeding if int(ep.responsible_id) == self.id]
        self.len_eps = len(self.eps)

listworker = [Worker(p) for p in request('SELECT * FROM workers', count_output=5)]