from flask import Flask, render_template, url_for
import database_manager


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('main.html')

@app.route('/auth')
def auth():
    return render_template('auth.html')

@app.route('/persons/<id>')
def person(id):
    return render_template('person.html', person=database_manager.Person(database_manager.request('SELECT * FROM person WHERE person_id=%s', id)))

@app.route('/persons')
def persons():
    return render_template('persons.html', persons=database_manager.listperson)

@app.route('/form')
def form():
    return render_template('form.html')

if __name__ == '__main__':
    app.run(debug=True)

# 