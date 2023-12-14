Ульяновский Александр Андреевич
<br /> Когорта: 8
<br /> Группа: 5
<br /> Эпик: Корзина
<br /> Ссылка: https://github.com/users/SKemenov/projects/3


#  Cart Flow Decomposition


## Module 1 - CartViewController:

#### Верстка
- NavigationBar, добавление иконки сортировки (est: 30 min; fact: 27 min).
- TabBar, добавление иконки корзины (est: 20 min; fact: 18 min).
- UIView, добавление кнопки "К оплате", лейблов с количеством и стоимостью всех NFT в корзине (est: 30 min; fact: 66 min).
- UITableView, добавление таблицы между NavigationBar и UIView (est: 30 min; fact: 45 min).
- .dequeueReusableCell, добавление класса кастомной ячейки для таблицы, добавление превью, лейбла с названием, рейтинга, лейблов с ценой, кнопки удаления из конзины (est: 60 min; fact: 139 min).
- UIViewController, добавление кастомного вью контроллера для демонстрации удаления (est: 60 min; fact: 205 min).

`Total:` est: 230 min; fact: 500 min.

#### Логика
- Добавление элемента в корзину (est: 60 min; fact: 99 min).
- Удаление элемента из корзины (est: 60 min; fact: 45 min).
- Сортировка элементов, алерт с вариантами сортировки (est: 120 min; fact: 140 min).
- Сохранение способа сортировки (est: 60 min; fact: 67 min).
- Подсчет количества и стоимости элементов (est: 30 min; fact: 34 min).
- Отображение "Корзина пуста" / кнопки "К оплате" в зависимости от наличия элементов в корзине (est: 30 min; fact: 35 min).

`Total:` est: 360 min; fact: 420 min.


## Module 2 - PaymentMethodViewController:

#### Верстка
- NavigationBar, кнопка возврата на предыдущий вью контроллер, лейбл "Выберите способ оплаты" (est: 30 min; fact: x min).
- UIView, добавление вью с привязкой к нижней части экрана, наполнение лейблами "Совершая покупку..", "Пользовательское соглашение", кнопкой "Оплатить" (est: 30 min; fact: x min).
- UICollectionView, добавление коллекции между NavigationBar и UIView (est: 30 min; fact: x min).
- .dequeueReusableCell, добавление класса кастомной ячейки для коллекции, добавление превью, лейбла с названием валюты, лейбла с аббревиатурой (est: 60 min; fact: x min).
- UIViewController, добавить вью контроллер "Успех! Оплата прошла.." (est: 60 min; fact: x min)

`Total:` est: 210 min; fact: x min.

#### Логика
- Добавить выбор элемента коллекции (est: 60 min; fact: x min).
- Добавить алерт "Не удалось произвести оплату (est: 60 min; fact: x min)
- UIWebView, добавить веб-вью для демонстрации пользовательского соглашения (est: 120 min; fact: x min)

`Total:` est: 240 min; fact: x min.

## Module 3 - Работа с API:

- Создание сетевого слоя для получения данных, необходимых для CartViewController - количество элементов и их тип, стоимость, рейтинг (est: 240 min; fact: x min).
- Создание сетевого слоя для получения данных, необходимых для PaymentMethodViewController - выбранный способ оплаты, наличие необходимого количества средств на счету (est: 120 min; fact: x min)
- Создание сетевого слоя оплаты содердимого корзины, удаления NFT из корзины (est: 120 min; fact: x min)

`Total:` est: 480 min; fact: x min.




