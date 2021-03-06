from flask import Flask, render_template, url_for, request, redirect
import database_manager

app = Flask(__name__)

logged = False
user = None


def logged_control(function_to_decorate):
    def wrapper(*args, **kwargs):
        if logged:
            print('True')
            function_to_decorate(*args, **kwargs)
        else:
            return redirect('/auth')
    return wrapper


@app.route('/')
def index():
    if logged:
        return render_template('main.html', post_id=user.post_id)
    else:
        return redirect('/auth')


@app.route('/auth', methods=['POST', 'GET'])
def auth():
    global logged, user
    if request.method == 'POST':
        login = request.form['floatingInput']
        password = request.form['floatingPassword']
        if not database_manager.auth(login, password):
            return redirect('/auth')
        for w in database_manager.listworker:
            if w.login == login:
                user = w
        logged = True
        return redirect('/')
    else:
        logged = False
        return render_template('auth.html')


@app.route('/persons/<id>')
def person(id):
    if logged:
        return render_template('person.html', person=database_manager.Person(database_manager.request('SELECT * FROM person WHERE person_id=%s', id)))
    else:
        return redirect('/auth')


@app.route('/persons', methods=['POST', 'GET'])
def persons():
    if request.method == 'POST':
        search = request.form['floatingInput']
        search_list = [
            p for p in database_manager.listperson if search in p.fullname]
        return render_template('persons.html', persons=search_list)
    else:
        if logged:
            return render_template('persons.html', persons=database_manager.listperson)
        else:
            return redirect('/auth')

'''
class GetForm:
    def __init__(request_form):
        request_form['']
'''


@app.route('/form', methods=['POST', 'GET'])
def form():
    if request.method != 'POST':
        try:
            pass
        except:
            return redirect('/')
        if logged:
            return render_template('form.html', regions=[i[0] for i in database_manager.request('SELECT name FROM admin.area', count_output=5)])
        else:
            return redirect('/auth')


@app.route('/eps')
def eps():
    if not logged:
        return redirect('/auth')
    eps = [ep for ep in database_manager.listenforchmentproceeding if int(ep.responsible_id) == user.id]
    return render_template('eps.html', eps=eps)


@app.route('/eps/<id>')
def ep(id):
    if logged:
        return render_template('eps.html', ep=id)
    else:
        return redirect('/auth')


@app.route('/workers')
def workers():
    if not logged:
        return redirect('/auth')
    list_dep_workers = [w for w in database_manager.listworker if w.department_id == user.department_id]
    return render_template('workers.html', workers=list_dep_workers)



@app.route('/workers/<id>')
def worker(id):
    if logged:
        return render_template('worker.html', worker=database_manager.Worker(database_manager.request('SELECT * FROM workers WHERE workers_id=%s', id)))
    else:
        return redirect('/auth')


if __name__ == '__main__':
    app.run(debug=True)
