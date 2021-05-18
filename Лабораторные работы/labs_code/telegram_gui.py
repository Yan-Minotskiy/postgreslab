from db_manager import DbManager
from aiogram import Bot, Dispatcher, executor, types
from aiogram.types import BotCommand
from aiogram.dispatcher.filters.state import State, StatesGroup
from aiogram.dispatcher import FSMContext
from aiogram.contrib.fsm_storage.memory import MemoryStorage
from aiogram.dispatcher.filters import Text, IDFilter

bot = Bot("1796050067:AAFwAh-xzLSddy3Cmr2olc7armhhfaoq0PY")
dp = Dispatcher(bot, storage=MemoryStorage())
db_mng = DbManager()


def register_handlers_common(dp: Dispatcher):
    dp.register_message_handler(start, commands="start", state="*")
    dp.register_message_handler(login_step1, commands="login", state="*")
    dp.register_message_handler(login_step1, Text(equals="авторизация", ignore_case=True), state="*")
    dp.register_message_handler(login_step1, Text(equals="войти с другого аккаунта", ignore_case=True), state="*")
    dp.register_message_handler(menu, Text(equals="перейти в меню", ignore_case=True), state="*")
    dp.register_message_handler(menu, Text(equals="меню", ignore_case=True), state="*")
    dp.register_message_handler(menu, commands="menu", state="*")
    dp.register_message_handler(task, commands="task", state="*")
    dp.register_message_handler(task, Text(equals="задания", ignore_case=True), state="*")
    dp.register_message_handler(excelreport, commands="excelreport", state="*")
    


async def start(message):
    if db_mng.user.login == 'unauthorized':
        await message.answer('Добрый день, {0.first_name}.\n'
                             'Для использования системы необходимо пройти авторизацию\n'
                             'Нажмите на кнопку или введите команду /login\n'.format(message.from_user))
    else:
        await message.answer(f'Добрый день! Вы вошли в систему как {db_mng.user.name} {db_mng.user.surname}.')


class Auth(StatesGroup):
    log_in = State()
    password = State()


def register_handlers_login(dp: Dispatcher):
    dp.register_message_handler(login_step1, commands="login", state="*")
    dp.register_message_handler(login_step2, state=Auth.log_in)
    dp.register_message_handler(login_step3, state=Auth.password)


async def login_step1(message):
    if db_mng.user.status > 0:
        global db_mng = DbManager()
    await message.answer("Логин:")
    await Auth.log_in.set()


async def login_step2(message: types.Message, state: FSMContext):
    await state.update_data(login=message.text)
    await Auth.next()
    await message.answer("Пароль:")


async def login_step3(message: types.Message, state: FSMContext):
    user_data = await state.get_data()
    try:
        db_mng.authorization(user_data['login'], message.text)
        keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
        button_1 = types.KeyboardButton(text="Перейти в меню")
        keyboard.add(button_1)
        await message.answer(f'Вы вошли в систему как {db_mng.user.name} {db_mng.user.surname}.', reply_markup=keyboard)
    except:
        await message.answer('Неудачная попытка входа. Попробуйте ещё раз')
    await state.finish()


async def menu(message: types.Message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    if db_mng.user.status == 0:
        await message.answer("Для начала работы пройдите авторизацию.")
        buttons = ['Авторизация']
    elif db_mng.user.status == 1:
        buttons = ['Задания', 'Клиенты', 'Оборудование', 'Войти с другого аккаунта']
    elif db_mng.user.status == 2:
        buttons = ['Задания', 'Клиенты', 'Оборудование', 'Работники', 'Контракты', 'Войти с другого аккаунта']
    keyboard.add(*buttons)
    await message.answer("Используйте кнопки и команды для выбора.", reply_markup=keyboard)

async def task(message: types.Message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    buttons = []
    if db_mng.user.status >= 1:
        buttons = ['Отметить выполненным', 'Отчёт в Excel']
        li = db_mng.task_to_list(db_mng.show_task())
        string = ''
        for i in li:
            string = string[:] + i + '\n\n'
    else:
        buttons = ['Авторизация']
        keyboard.add(*buttons)
        await message.answer('Для доступа к заданиям необходима авторизацция!', reply_markup=keyboard)
        return
    if db_mng.user.status >= 2:
        buttons.extend(['Создать задание', 'Меню'])
    keyboard.add(*buttons)
    if string == '':
        string = "Нет заданий."
    await message.answer(string, reply_markup=keyboard)


# ! TODO: доделать
async def excelreport(message: types.Message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    if db_mng.user.status < 1:
        buttons = ['Авторизация']
        keyboard.add(*buttons)
        await message.answer('Для доступа к заданиям необходима авторизацция!', reply_markup=keyboard)
        return
    db_mng.excel_report()
    await message.answer_document("./report.xlsx")


async def newtask_step1(message: types.Message):
    
    await message.answer("Название задние:")
    await Auth.log_in.set()    


async def newtask_step2(message: types.Message):
    pass

async def newtask_step3(message: types.Message):
    pass

async def complite_step1(message: types.Message):
    pass

async def complite_step2(message: types.Message):
    pass

async def workers(message: types.Message):
    pass

async def workertask_step1(message: types.Message):
    pass

async def workertask_step2(message: types.Message):
    pass

async def searchclient_step1(message: types.Message):
    pass

async def searchclient_step2(message: types.Message):
    pass

async def models(message: types.Message):
    pass

async def newequipment_step1(message: types.Message):
    pass

async def newequipment_step2(message: types.Message):
    pass

async def contract(message: types.Message):
    pass

async def newcontract_step1(message: types.Message):
    pass

async def newcontract_step2(message: types.Message):
    pass

async def newcontract_step3(message: types.Message):
    pass

async def freerequest_step1(message: types.Message):
    pass

async def freerequest_step2(message: types.Message):
    pass


if __name__ == '__main__':
    register_handlers_common(dp)
    register_handlers_login(dp)
    executor.start_polling(dp)