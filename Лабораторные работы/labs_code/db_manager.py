import psycopg2
import pandas as pd


class DbManager(object):
    """Класс СУБД"""

    @property
    def empty(self):
        """Проверка пустоты результата запроса"""
        return self.cursor.fetchall() == []

    class User(object):
        """Класс пользователя базы данных."""

        def __init__(self, login):
            cursor  = psycopg2.connect(
            dbname='lab', user='postgres', password='123', host='localhost').cursor()
            cursor.execute(
                'SELECT * FROM worker WHERE worker.login=%s', (login,))
            res = cursor.fetchall()[0]
            self.login = res[0]
            self.name = res[1]
            self.surname = res[2]
            self.password = res[3]
            self.status = res[4]

    def __init__(self):
        self.conn = psycopg2.connect(
            dbname='lab', user='postgres', password='123', host='localhost')
        self.cursor = self.conn.cursor()
        self.user = self.User("unauthorized")

    def def_rights(*rights):
        """Декоратор для проверки прав на использование функций."""

        def decorator(method_to_decorate):
            def wrapper(self, *args, **kwargs):
                if self.user.status in rights:
                    return method_to_decorate(self, *args, **kwargs)

            return wrapper

        return decorator

    def write_log(self, action):
        self.cursor.execute("INSERT INTO journal (action_code, user_id) VALUES (%s, %s)",
                            (action, self.user.login))
        self.conn.commit()

    """------Работа с пользователями системы------"""

    @def_rights(0)
    def authorization(self, login, password):
        self.cursor.execute("SELECT login FROM worker "
                            "WHERE login=%s AND password=%s", (login, password))
        res = self.cursor.fetchall()
        if res != []:
            self.user = self.User(res[0])
            self.write_log(1)
            return True

    @def_rights(1, 2, 3)
    def exit(self):
        self.write_log(2)
        self.user = self.User("unauthorized")

    @def_rights(3)
    def register(self, name, surname, login, password, status):
        self.cursor.execute("SELECT login FROM worker"
                            "WHERE login=%s", (login,))
        if self.empty:
            self.cursor.execute("INSERT INTO worker (login, name, surname, password, status_id)"
                                "VALUE (%s, %s, %s, %s, %s)",
                                (login, name, surname, password, status))
            self.conn.commit()
            self.write_log(3)

    @def_rights(3)
    def delete_user(self, login):
        self.cursor.execute("DELETE FROM worker"
                            "WHERE login=%s", (login,))
        self.conn.commit()
        self.write_log(4)

    @def_rights(3)
    def change_user_data(self, old_login, new_login, new_name, new_surname, new_password, new_status):
        self.cursor.execute("UPDATE worker SET login=%s, name=%s, surname=%s, password=%s, status_id=%s"
                            "WHERE login=%s",
                            (new_login, new_name, new_surname, new_password, new_status, old_login))
        self.conn.commit()
        self.write_log(5)

    """------Обрабока заданий------"""

    def clean_task(self):
        """Удаление заданий годовалой давности"""
        self.cursor.execute(
            "DELETE FROM task WHERE age(task.create)<interval '1 year'")
        self.conn.commit()

    @def_rights(2, 3)
    def create_task(self, executor, name, description, deadline="NULL", priority_id=2, client="NULL"):
        self.clean_task()
        self.cursor.execute("INSERT INTO task (author, executor, name, description, deadline,  priority_id, client)"
                            "VALUE (%s, %s, %s, %s, %s, %s, %s)",
                            (executor, name, description, deadline, executor, priority_id, client))
        self.conn.commit()
        self.write_log(6)

    @def_rights(1, 2, 3)
    def show_task(self, role="executor", with_complete=False):
        # ! self.clean_task() не работает
        if role == "executor":
            if with_complete:
                return pd.read_sql("SELECT FROM task "
                                   "WHERE executor=" + self.user.login +
                                   " ORDER BY complete DESC NULLS FIRST, priority,"
                                   " deadline NULLS LAST, id", self.conn)
            else:
                return pd.read_sql("SELECT * FROM task "
                                   "WHERE executor='" + self.user.login + "' AND complete IS NULL "
                                   "ORDER BY priority_id, deadline NULLS LAST, id",
                                   self.conn)
        elif role == "author":
            if with_complete:
                return pd.read_sql("SELECT * FROM task "
                                   "WHERE author=" + self.user.login +
                                   " ORDER BY complete DESC NULLS FIRST, priority,"
                                   "deadline NULLS LAST, id", self.conn)
            else:
                return pd.read_sql("SELECT * FROM task "
                                   "WHERE author=" + self.user.login + " AND complete IS NULL"
                                                                       " ORDER BY priority, deadline NULLS LAST, id",
                                   self.conn)

    def task_to_list(self, qr:pd.DataFrame):
        task_cards = []
        for i, row in qr.iterrows():
            card = f"#{row['id']}\n{row['name']}\n{row['description']}\nавтор: {row['author']}\nисполнитель: {row['executor']}\nсоздано: {row['create']}\n"
            task_cards.append(card)
        return task_cards


    @def_rights(2, 3)
    def edit_task(self, id, new_name, new_description, new_executor, new_deadline="NULL", new_priority_id=2,
                  client="NULL"):
        self.clean_task()
        self.cursor.execute("SELECT id, author, FROM task"
                            "WHERE id=%s AND author=%s", (id, self.user.login))
        if not self.empty or self.user.status == 3:
            self.cursor.execute("UPDATE task "
                                "SET executor=%s, name=%s, description=%s, deadline=%s,  priority_id=%s, client=%s"
                                "WHERE id=%s",
                                (new_executor, new_name, new_description, new_deadline, new_priority_id, client, id))
            self.conn.commit()
            self.write_log(7)

    @def_rights(1, 2, 3)
    def complete_task(self, id):
        self.clean_task()
        self.cursor.execute(
            "UPDATE task SET complete=CURRENT_TIMESTAMP WHERE id=" + str(id))
        self.conn.commit()
        self.write_log(8)

    @def_rights(2, 3)
    def delete_task(self, id):
        self.clean_task()
        self.cursor.execute("SELECT * FROM task"
                            "WHERE id=" + str(id) + " AND author=" + self.user.login)
        if self.user.status == 3 or not self.empty:
            self.cursor.execute("DELETE FROM task WHERE id=" + str(id))
            self.conn.commit()
            self.write_log(9)

    """------Работа с базой клиентов------"""

    @def_rights(1, 2, 3)
    def add_client(self, name, surname, address="NULL", email="NULL", phone="NULL", organization="NULL"):
        self.cursor.execute("INSERT INTO client VALUE (%s, %s, %s, %s, %s, %s)",
                            (name, surname, address, email, phone, organization))
        self.conn.commit()
        self.write_log(10)

    @def_rights(3)
    def edit_client(self, id, name, surname, address, email, phone, organization):
        self.cursor.execute("UPDATE client "
                            "SET name=%s, surname=%s, address=%s, email=%s,  phone=%s, organization=%s"
                            "WHERE id=%s",
                            (name, surname, address, email, phone, organization, id))
        self.conn.commit()
        self.write_log(11)

    @def_rights(3)
    def delete_client(self, id):
        self.cursor.execute("DELETE FROM client WHERE id=" + str(id))
        self.conn.commit()
        self.write_log(12)

    """------Работа с базой товаров------"""

    @def_rights(2, 3)
    def add_model(self, name, article_number, parameters="NULL"):
        self.cursor.execute("INSERT INTO model (name, article_number, parameters) VALUE (%s, %s, %s)",
                            (name, article_number, parameters))
        self.conn.commit()
        self.write_log(13)

    @def_rights(3)
    def edit_model(self,  article_number, name, parameters):
        self.cursor.execute("UPDATE model SET article_number=%s parameters=%s WHERE article_number=%s",
                            (name, parameters, article_number))
        self.conn.commit()
        self.write_log(14)

    @def_rights(3)
    def delete_model(self, article_number):
        self.cursor.execute(
            "DELETE FROM model WHERE article_number=" + str(article_number))
        self.conn.commit()
        self.write_log(15)

    @def_rights(2, 3)
    def add_equipment(self, model, create_date="CURRENT_DATE", contract_number="NULL"):
        self.cursor.execute("INSERT INTO add_equipment (model, create_date, contract_number) "
                            "VALUE (%s, %s, %s)",
                            (model, create_date, contract_number))
        self.conn.commit()
        self.write_log(20)

    @def_rights(3)
    def edit_equipment(self, id):
        self.cursor.execute("UPDATE equipment SET model=%s create_date=%s contract_number=%s"
                            "WHERE id=%s",
                            (id,))
        self.conn.commit()
        self.write_log(21)

    @def_rights(3)
    def delete_equipment(self, id):
        self.cursor.execute("DELETE FROM equipment WHERE id=" + str(id))
        self.conn.commit()
        self.write_log(22)

    """------Работа с документацией------"""

    @def_rights(2, 3)
    def create_contract(self, number, client, create_date):
        self.cursor.execute("INSERT INTO contract (number, client, create_date) "
                            "VALUE (%s, %s, %s)",
                            (number, client, create_date))
        self.conn.commit()
        self.write_log(16)

    @def_rights(3)
    def edit_contract(self, number, new_number, client, create_date):
        self.cursor.execute("UPDATE contract SET number=%s, client=%s, create_date=%s) "
                            "VALUE (%s, %s, %s, %s)",
                            (new_number, number, client, create_date))
        self.conn.commit()
        self.write_log(17)

    @def_rights(3)
    def delete_contract(self, number):
        self.cursor.execute("DELETE FROM contract WHERE number=" + str(number))
        self.conn.commit()
        self.write_log(18)

    @def_rights(1, 2, 3)
    def excel_report(self, path="./report.xlsx", role="executor", with_complete=False):
        self.show_task(role, with_complete).to_excel(path, "Отчёт")
        self.write_log(19)

    """------Специальный функционал для администраторов базы данных------"""

    def clean_journal(self):
        self.cursor.execute(
            "DELETE FROM journal WHERE age(timestamp) < interval '1 month'")
        self.conn.commit()

    @def_rights(3)
    def show_journal(self):
        self.clean_journal()
        self.write_log(23)
        return pd.read_sql("SELECT * FROM journal")

    @def_rights(3)
    def free_request(self, request):
        self.cursor.execute(request)
        self.conn.commit()
        self.write_log(24)
        return self.cursor.fetchall()
