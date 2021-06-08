from flask import Flask, render_template, url_for
from flask import request, redirect
import database_manager

app = Flask(__name__)

check = False

@app.route('/')
def index():
    return render_template('main.html')

@app.route('/auth', methods=['POST', 'GET'])
def auth():
    if request.method == 'POST':
        login = request.form['floatingInput']
        password = request.form['floatingPassword']
        if database_manager.auth(login, password):
            print('!')
            check = True
            return redirect('/')
        print('!!')
        check = False
        return redirect('/auth')
    else:
        check = False
        print('!!')
        return render_template('auth.html')

@app.route('/persons/<id>')
def person(id):
    return render_template('person.html', check=check, person=database_manager.Person(database_manager.request('SELECT * FROM person WHERE person_id=%s', id)))

@app.route('/persons')
def persons():
    return render_template('persons.html', check=check, persons=database_manager.listperson)

@app.route('/form')
def form():
    return render_template('form.html')

@app.route('/eps')
def eps():
    return render_template('eps.html', check=check, eps=database_manager.listenforchmentproceeding)

@app.route('/eps/<id>')
def ep(id):
    return render_template('eps.html', check=check, ep=id)

@app.route('/workers/<id>')
def worker(id):
    return  render_template('worker.html', check=check, worker=database_manager.Worker(database_manager.request('SELECT * FROM workers WHERE workers_id=%s', id)))


if __name__ == '__main__':
    app.run(debug=True)

# 