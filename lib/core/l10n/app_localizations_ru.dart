// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'HisobKit';

  @override
  String get home => 'Главная';

  @override
  String get transactions => 'Транзакции';

  @override
  String get reports => 'Отчёты';

  @override
  String get debts => 'Долги';

  @override
  String get settings => 'Настройки';

  @override
  String get totalBalance => 'Общий баланс';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get income => 'Доходы';

  @override
  String get expense => 'Расходы';

  @override
  String get transfer => 'Перевод';

  @override
  String get recentTransactions => 'Последние транзакции';

  @override
  String get activeBudgets => 'Активные бюджеты';

  @override
  String get upcomingDebts => 'Ближайшие долги';

  @override
  String get noTransactions => 'Транзакций нет';

  @override
  String get noTransactionsHint => 'Нажмите + чтобы добавить первую транзакцию';

  @override
  String get noBudgets => 'Активных бюджетов нет';

  @override
  String get noBudgetsHint => 'Создайте бюджет для отслеживания расходов';

  @override
  String get noDebts => 'Долги не записаны';

  @override
  String get noDebtsHint =>
      'Отслеживайте деньги, которые вы дали или взяли в долг';

  @override
  String get noAccounts => 'Счетов нет';

  @override
  String get noAccountsHint => 'Добавьте счёт для начала работы';

  @override
  String get noCategories => 'Категории не найдены';

  @override
  String get addTransaction => 'Добавить транзакцию';

  @override
  String get editTransaction => 'Редактировать транзакцию';

  @override
  String get deleteTransaction => 'Удалить транзакцию';

  @override
  String get deleteTransactionConfirm =>
      'Вы уверены, что хотите удалить эту транзакцию?';

  @override
  String get amount => 'Сумма';

  @override
  String get category => 'Категория';

  @override
  String get account => 'Счёт';

  @override
  String get toAccount => 'На счёт';

  @override
  String get note => 'Примечание (необязательно)';

  @override
  String get date => 'Дата';

  @override
  String get recurring => 'Повторяющаяся';

  @override
  String get recurrenceRule => 'Повтор';

  @override
  String get daily => 'Ежедневно';

  @override
  String get weekly => 'Еженедельно';

  @override
  String get monthly => 'Ежемесячно';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get addAccount => 'Добавить счёт';

  @override
  String get editAccount => 'Редактировать счёт';

  @override
  String get deleteAccount => 'Удалить счёт';

  @override
  String get deleteAccountConfirm =>
      'Удалить этот счёт? Все транзакции также будут удалены.';

  @override
  String get accountName => 'Название счёта';

  @override
  String get accountType => 'Тип счёта';

  @override
  String get cash => 'Наличные';

  @override
  String get card => 'Карта';

  @override
  String get savings => 'Сбережения';

  @override
  String get currency => 'Валюта';

  @override
  String get balance => 'Баланс';

  @override
  String get initialBalance => 'Начальный баланс';

  @override
  String get color => 'Цвет';

  @override
  String get icon => 'Иконка';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String get deleteCategoryConfirm => 'Удалить эту категорию?';

  @override
  String get categoryName => 'Название категории';

  @override
  String get parentCategory => 'Родительская категория (необязательно)';

  @override
  String get incomeCategory => 'Доходы';

  @override
  String get expenseCategory => 'Расходы';

  @override
  String get addBudget => 'Добавить бюджет';

  @override
  String get editBudget => 'Редактировать бюджет';

  @override
  String get deleteBudget => 'Удалить бюджет';

  @override
  String get deleteBudgetConfirm => 'Удалить этот бюджет?';

  @override
  String get budgetAmount => 'Сумма бюджета';

  @override
  String get budgetPeriod => 'Период';

  @override
  String get startDate => 'Дата начала';

  @override
  String get endDate => 'Дата окончания';

  @override
  String get alertAt => 'Уведомить при';

  @override
  String get spent => 'Потрачено';

  @override
  String get remaining => 'Осталось';

  @override
  String get ofWord => 'из';

  @override
  String get budgetOverview => 'Обзор бюджетов';

  @override
  String get lent => 'Я дал в долг';

  @override
  String get borrowed => 'Я взял в долг';

  @override
  String get addDebt => 'Добавить долг';

  @override
  String get editDebt => 'Редактировать долг';

  @override
  String get deleteDebt => 'Удалить долг';

  @override
  String get deleteDebtConfirm => 'Удалить запись о долге?';

  @override
  String get personName => 'Имя человека';

  @override
  String get dueDate => 'Срок';

  @override
  String get markAsPaid => 'Отметить как оплаченный';

  @override
  String get addPayment => 'Добавить платёж';

  @override
  String get paymentAmount => 'Сумма платежа';

  @override
  String get totalLent => 'Всего дано в долг';

  @override
  String get totalBorrowed => 'Всего взято в долг';

  @override
  String get paid => 'Оплачено';

  @override
  String get unpaid => 'Не оплачено';

  @override
  String get overdue => 'Просрочено';

  @override
  String get partiallyPaid => 'Частично оплачено';

  @override
  String get debtSummary => 'Сводка долгов';

  @override
  String get payments => 'Платежи';

  @override
  String get noPayments => 'Платежей нет';

  @override
  String get monthlyReport => 'Ежемесячный отчёт';

  @override
  String get yearlyReport => 'Годовой отчёт';

  @override
  String get incomeVsExpense => 'Доходы и расходы';

  @override
  String get expenseByCategory => 'Расходы по категориям';

  @override
  String get topCategories => 'Топ категорий';

  @override
  String get selectDateRange => 'Выберите период';

  @override
  String get thisMonthRange => 'Этот месяц';

  @override
  String get lastMonth => 'Прошлый месяц';

  @override
  String get thisYear => 'Этот год';

  @override
  String get customRange => 'Свой период';

  @override
  String get from => 'С';

  @override
  String get to => 'По';

  @override
  String get apply => 'Применить';

  @override
  String get accountBreakdown => 'По счетам';

  @override
  String get noData => 'Нет данных за выбранный период';

  @override
  String get exportPdf => 'Экспорт PDF';

  @override
  String get exportExcel => 'Экспорт Excel';

  @override
  String get export => 'Экспорт';

  @override
  String get share => 'Поделиться';

  @override
  String get exportSuccess => 'Экспорт выполнен';

  @override
  String get exportFailed => 'Ошибка экспорта';

  @override
  String get generating => 'Создание...';

  @override
  String get language => 'Язык';

  @override
  String get uzbek => 'O\'zbek';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get baseCurrency => 'Основная валюта';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get biometrics => 'Биометрическая блокировка';

  @override
  String get biometricsEnabled => 'Биометрика включена';

  @override
  String get biometricsDisabled => 'Биометрика отключена';

  @override
  String get autoLock => 'Автоблокировка';

  @override
  String get never => 'Никогда';

  @override
  String get minute1 => '1 минута';

  @override
  String get minutes5 => '5 минут';

  @override
  String get minutes10 => '10 минут';

  @override
  String get minutes30 => '30 минут';

  @override
  String get exchangeRates => 'Курсы валют';

  @override
  String get updateRate => 'Обновить курс';

  @override
  String get rate => 'Курс (к UZS)';

  @override
  String get backupData => 'Резервная копия';

  @override
  String get restoreData => 'Восстановить данные';

  @override
  String get backupSuccess => 'Резервная копия создана';

  @override
  String get restoreSuccess => 'Данные успешно восстановлены';

  @override
  String get restoreFailed => 'Восстановление не удалось — неверный файл';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get clearAllDataConfirm =>
      'Это удалит ВСЕ данные: счета, транзакции и настройки. Это действие нельзя отменить.';

  @override
  String get clearAllDataSuccess => 'Все данные очищены';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get lockScreen => 'HisobKit заблокирован';

  @override
  String get enterPin => 'Введите PIN';

  @override
  String get useBiometrics => 'Использовать биометрику';

  @override
  String get wrongPin => 'Неверный PIN. Попробуйте снова.';

  @override
  String get setPin => 'Установить PIN';

  @override
  String get confirmPin => 'Подтвердить PIN';

  @override
  String get pinMismatch => 'PIN-коды не совпадают';

  @override
  String get pinSet => 'PIN успешно установлен';

  @override
  String get changePin => 'Изменить PIN';

  @override
  String get currentPin => 'Текущий PIN';

  @override
  String get newPin => 'Новый PIN';

  @override
  String get welcome => 'Добро пожаловать в HisobKit';

  @override
  String get welcomeSubtitle => 'Ваш личный финансовый трекер';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get chooseBaseCurrency => 'Выберите основную валюту';

  @override
  String get setupPin => 'Установить PIN';

  @override
  String get setupBiometrics => 'Включить биометрику';

  @override
  String get skip => 'Пропустить';

  @override
  String get next => 'Далее';

  @override
  String get done => 'Готово';

  @override
  String get getStarted => 'Начать';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get add => 'Добавить';

  @override
  String get close => 'Закрыть';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String get search => 'Поиск';

  @override
  String get filter => 'Фильтр';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get all => 'Все';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get savedSuccessfully => 'Сохранено успешно';

  @override
  String get deletedSuccessfully => 'Удалено успешно';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get requiredField => 'Это поле обязательно';

  @override
  String get invalidAmount => 'Неверная сумма';

  @override
  String get amountMustBePositive => 'Сумма должна быть больше 0';

  @override
  String get accounts => 'Счета';

  @override
  String get categories => 'Категории';

  @override
  String get budgets => 'Бюджеты';

  @override
  String get manageAccounts => 'Управление счетами';

  @override
  String get manageCategories => 'Управление категориями';

  @override
  String get manageBudgets => 'Управление бюджетами';

  @override
  String get quickAdd => 'Быстрое добавление';

  @override
  String get houseTab => 'Дом';

  @override
  String get houseExpenses => 'Расходы дома';

  @override
  String get addHouseExpense => 'Добавить расход';

  @override
  String get presentMembers => 'Кто присутствовал?';

  @override
  String get perPerson => 'На человека';

  @override
  String get settlement => 'Расчёт';

  @override
  String get minTransfers => 'Минимум переводов';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get markBought => 'Отметить как куплено';

  @override
  String get addToExpenses => 'Добавить в расходы?';

  @override
  String get confirmSettlement => 'Завершить расчёт';

  @override
  String get settlementDone => 'Расчёт завершён';

  @override
  String get islamicContract => 'Исламский контракт';

  @override
  String get contractType => 'Тип контракта';

  @override
  String get qarzUlHasan => 'Карз уль-Хасан (беспроцентный)';

  @override
  String get witnesses => 'Свидетели';

  @override
  String get witness1 => 'Свидетель 1';

  @override
  String get witness2 => 'Свидетель 2';

  @override
  String get guarantor => 'Поручитель';

  @override
  String get collateral => 'Залог';

  @override
  String get paymentSchedule => 'График платежей';

  @override
  String get oneTime => 'Единовременно';

  @override
  String get installments => 'В рассрочку';

  @override
  String get contractPreview => 'Просмотр контракта';

  @override
  String get saveContract => 'Сохранить';

  @override
  String get shareContract => 'Поделиться';

  @override
  String get memberBalance => 'Баланс участника';

  @override
  String get groupSync => 'Синхронизация группы';

  @override
  String get syncViaQr => 'Через QR';

  @override
  String get importFromFile => 'Импорт из файла';

  @override
  String get mergeResult => 'Результат';

  @override
  String get todayLabel => 'Сегодня';

  @override
  String get yesterdayLabel => 'Вчера';

  @override
  String get chooseDateLabel => 'Выбрать дату';

  @override
  String get paidBy => 'Кто заплатил';

  @override
  String get groupName => 'Название группы';

  @override
  String get addMember => 'Добавить участника';

  @override
  String get memberName => 'Имя участника';

  @override
  String get noGroup => 'Нет группы';

  @override
  String get createGroup => 'Создать группу';

  @override
  String get netPosition => 'Чистая позиция';

  @override
  String get shareViaQr => 'Поделиться через QR';

  @override
  String get urgent => 'Срочно';

  @override
  String get normalPriority => 'Обычный';
}
