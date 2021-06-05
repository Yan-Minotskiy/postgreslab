from flask import Flask, render_template, url_for
import database_manager


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/auth')
def auth():
    return render_template('auth.html')

@app.route('/persons/<id>')
def person(id):
    return render_template('person.html', person=database_manager.Person(database_manager.request('SELECT * FROM person WHERE person_id=%s', id)))

if __name__ == '__main__':
    app.run(debug=True)

# 