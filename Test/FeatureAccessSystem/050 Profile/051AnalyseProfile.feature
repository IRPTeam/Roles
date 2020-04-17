#language: ru
@tree


Функционал: _051 создание профиля для анализа доступа

Как пользователь
Я хочу проанализировать профили доступа
Для выявления пересекающихся ролей


Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _051001 создание профиля и добавление в него роли для анализа
    * Открытие списка профилей
        И я открываю навигационную ссылку 'e1cib/list/Справочник.Roles_AccessProfiles'
    * Создание профиля и проверка добавления роли
        И я нажимаю на кнопку с именем 'ФормаСоздать'
        И в таблице "Roles" я нажимаю на кнопку с именем 'RolesAdd'
        И в таблице "Roles" я нажимаю кнопку выбора у реквизита "Роль"
        И в таблице "Список" я перехожу к строке:
            | 'Наименование' |
            | 'Роль2'        |
        И в таблице "Список" я выбираю текущую строку
        И в таблице "Roles" я завершаю редактирование строки
        И я нажимаю на кнопку 'Обновить матрицу'
    * Проверка отображения доступа по профилю
        И     таблица "Roles" стала равной:
            | 'Скрыть' | 'Роль'  |
            | 'Нет'    | 'Роль2' |
        И     табличный документ "TabDocMartix" равен:
            | 'Объект' | ''             | 'Объект'                     | 'Чтение' | 'Добавление' | 'Изменение' | 'Удаление' | 'Просмотр' | 'Редактирование' | 'Ввод по строке' | 'Использование' | 'Контроль итогов' | 'Интерактивное удаление' | 'Интерактивное добавление' | 'Интерактивная пометка на удаление' | 'Интерактивное снятие пометки удаления' | 'Интерактивное удаление помеченных' | 'Проведение' | 'Отменить проведение' | 'Интерактивное проведение' |
            | '✔'      | 'Конфигурация' | 'Configuration.Конфигурация' | ''       | ''           | ''          | ''         | ''         | ''               | ''               | ''              | ''                | ''                       | ''                         | ''                                  | ''                                      | ''                                  | ''           | ''                    | ''                         |
    * Сохранение профиля
        И в поле 'Наименование' я ввожу текст 'Тестовый профиль'
        И я нажимаю на кнопку 'Записать и закрыть'
    * Проверка обновления матрицы доступа в уже созданном профиле
        И в таблице "List" я перехожу к строке:
                | 'Наименование' |
                | 'Тестовый профиль'        |
        И в таблице "List" я выбираю текущую строку
        И я нажимаю на кнопку 'Обновить матрицу'
        И     табличный документ "TabDocMartix" равен:
            | 'Объект' | ''             | 'Объект'                     | 'Чтение' | 'Добавление' | 'Изменение' | 'Удаление' | 'Просмотр' | 'Редактирование' | 'Ввод по строке' | 'Использование' | 'Контроль итогов' | 'Интерактивное удаление' | 'Интерактивное добавление' | 'Интерактивная пометка на удаление' | 'Интерактивное снятие пометки удаления' | 'Интерактивное удаление помеченных' | 'Проведение' | 'Отменить проведение' | 'Интерактивное проведение' |
            | '✔'      | 'Конфигурация' | 'Configuration.Конфигурация' | ''       | ''           | ''          | ''         | ''         | ''               | ''               | ''              | ''                | ''                       | ''                         | ''                                  | ''                                      | ''                                  | ''           | ''                    | ''                         |
        И я закрыл все окна клиентского приложения
