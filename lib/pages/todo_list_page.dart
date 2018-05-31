import 'dart:async';

import 'package:flutter/material.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/date_time_item.dart';
import '../model/todo_item.dart';
import '../util/database_client.dart';

/// We need this key in order to access and modify [TodoListPage]'s [todoItemList]
///  in [_CreateNewTodoPageState].
final todoListPagekey = GlobalKey<_TodoListPageState>();

/// A tab where the user can consult his todo-list.
class TodoListPage extends StatefulWidget {
  TodoListPage({Key key}) : super(key: todoListPagekey);
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  /// This map holds two lists: [activeTodoItems] and [completedTodoItems].
  /// The reason we are not using these as two separate lists is because then
  /// it's a lot more work to transfer a [TodoItem] from one list to the
  /// other.
  Map<String, List<TodoItem>> _todoItemList = <String, List<TodoItem>>{
    "activeTodoItems": [],
    "completedTodoItems": [],
  };

  /// Getter for [_todoItemList].
  Map<String, List<TodoItem>> get todoItemList => _todoItemList;

  /// The key we use throughout this code to access one of the two list values
  /// in [_todoItemList]. On first run this is set to [activeTodoItems] as we
  /// want the user to first see the active items tab.
  String selectedList = "activeTodoItems";

  /// holds the BuildContext of the body of the [Scaffold] in TodoListPage.
  /// We need this to show [Snackbar]s.
  BuildContext _scaffoldContext;

  var db = DatabaseHelper();

  /// Denotes which tab in the BottomNavigationBar is selected.
  /// [0] stands for the [Active] tab and [1] is for the [Completed] tab.
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    readToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentoDrawer(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      appBar: StudentoAppBar(
        title: "Todo List",
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
          color: Colors.white,
          onPressed: () => print("You have tried to search."),)
        ],
      ),
      body: (todoItemList["activeTodoItems"].length == 0 && _selectedTab == 0) ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.lime, size: 50.0,),
              Padding(padding: EdgeInsets.all(10.0),),
              Text("Hooray, you don't have any todo items!"),
            ],
          ),
        ) :

        Builder(builder: (BuildContext context) {
          _scaffoldContext = context;
          return Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  reverse: false,
                  padding: EdgeInsets.all(8.0),
                  itemCount: todoItemList[selectedList].length,
                  itemBuilder: (_, int index) => _buildDismissible(index),
                ),
              ),
              Divider(
                height: 1.0,
              ),
            ],
          );
        },
      ),
    );
  }

  /// The background builder for the Dismissible in [TodoListPage].
  Widget _buildDissmissibleBackground({
    Color color,
    IconData icon,
    FractionalOffset align = FractionalOffset.centerLeft,
  }) => Container(
    height: 42.0,
    color: color,
    child: Icon(icon, color: Colors.white70),
    alignment: align,
  );

  /// The background for delete swipe action.
  Widget _buildSecondaryDismissibleBackground() => _buildDissmissibleBackground(
    color: Colors.red,
    icon: Icons.delete,
    align: FractionalOffset.centerRight,
  );

  /// The background for the complete swipe action.
  /// In case this function is used in the Completed tab,
  /// this background is the same as the primary background.
  /// TODO The key of the dismissible is duplicated when widget is rebuilt,
  /// we need to fix that.
  Widget _buildDismissible(int index) {
    return Dismissible(
      key: UniqueKey(),
      child: todoItemList[selectedList][index],
      background: (selectedList == "activeTodoItems")
        ? _buildDissmissibleBackground(color: Colors.lime, icon: Icons.check)
        : _buildSecondaryDismissibleBackground(),
      secondaryBackground: _buildSecondaryDismissibleBackground(),
      onDismissed: (direction) {
        int _id = todoItemList[selectedList][index].id;
        if (_selectedTab == 0  && direction == DismissDirection.startToEnd) {
          completeTodoItem(_id, index);
        } else {
          deleteTodoItem(_id, index);
        }
      },
    );
  }

  /// Builds the [BotttomNavigationBar] that contains the Active and
  /// Completed tab.
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (int screen) => switchTabs(screen),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.timer), title: Text("Active")),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          title: Text("Completed"),
        ),
      ],
    );
  }

  /// Returns a FloatingActionButton that opens up [CreateNewTodoPage] when tapped.
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      tooltip: "Create Todo",
      foregroundColor: Colors.white,
      child: Icon(Icons.add, size: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      onPressed: () =>
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => CreateNewTodoPage(_scaffoldContext)
        ),
      ),
    );
  }

  /// Gets the lists of active and completed [todoItem]s from the database
  /// and pushes them into [todoItemList["activeTodoItems"]] and
  /// [todoItemList["completedTodoItems"]] respectively.
  void readToDoList() async {
    List activeItems = await db.getItems(isComplete: false);
    activeItems.forEach((item) {
      TodoItem todoItem = TodoItem.fromMap(item);
      setState(() =>
        todoItemList["activeTodoItems"].insert(0, todoItem)
      );
      print("Db items: ${todoItem.itemName}");
    });

    List completedItems = await db.getItems(isComplete: true);
    completedItems.forEach((item) {
      TodoItem todoItem = TodoItem.fromMap(item);
      setState(() =>
        todoItemList["completedTodoItems"].insert(0, todoItem)
      );
    });
  }

  /// Mark the item as complete by changing its [isComplete] property to [true].
  /// Then, we update the database record as well as the [todoItemList].
  void completeTodoItem(int id, int index) async {
    TodoItem updatedItem = await db.getItem(id);
    updatedItem.isComplete = true;
    db.updateItem(updatedItem);
    setState(() {
      todoListPagekey.currentState.todoItemList["activeTodoItems"]
          .removeAt(index);
      todoListPagekey.currentState.todoItemList["completedTodoItems"]
          .insert(0, updatedItem);
    });
  }

  /// The item whose id is passed is deleted from the database and the
  /// [todoItemList]. User is then notified by a [SnackBar]. If "UNDO" action
  /// in the [SnackBar] is pressed, item is restored.
  void deleteTodoItem(int id, int index) async {
    TodoItem deletedItem = await db.getItem(id);
    db.deleteItem(id);
    // Remove item from the list.
    setState(() => todoItemList[selectedList].removeAt(index));

    Scaffold.of(_scaffoldContext).showSnackBar(
      SnackBar(
        content: Text("This To-do has been deleted."),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              db.saveItem(deletedItem);
              // Add item back into the list at its original position.
              todoItemList[selectedList].insert(index, deletedItem);
            });
          },
        ),
      ),
    );
  }

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// tab index. Based on the index, we update the
  /// [selectedList] as well as [_selectedTab].
  void switchTabs(int tabIndex) {
    String _selectedList;
    if (tabIndex == 0)
      _selectedList = "activeTodoItems";
    else
      _selectedList = "completedTodoItems";

    setState(() {
      _selectedTab = tabIndex;
      selectedList = _selectedList;
    });
  }
}

class CreateNewTodoPage extends StatefulWidget {
  /// The context of the [Scaffold] in [TodoListPage]. We need this
  /// BuildContext to show the [SnackBar]s.
  BuildContext _scaffoldContext;

  CreateNewTodoPage(this._scaffoldContext);
  @override
  _CreateNewTodoPageState createState() => _CreateNewTodoPageState();
}

class _CreateNewTodoPageState extends State<CreateNewTodoPage> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _detailsEditingController =
      TextEditingController();
  var db = DatabaseHelper();
  DateTime _dueDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    _titleEditingController.dispose();
    _detailsEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentoAppBar(title: "Create Todo"),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      onWillPop: showConfirmationDialog,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.bottomLeft,
            child: TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(
                filled: true,
                icon: Icon(Icons.note_add),
                hintText: "E.g do Physics homework",
                labelText: "Title",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.bottomLeft,
            child: TextField(
              maxLength: 300,
              maxLines: 3,
              controller: _detailsEditingController,
              decoration: InputDecoration(
                filled: true,
                labelText: "Details",
                icon: Icon(Icons.details),
                contentPadding: EdgeInsets.all(15.0),
                hintText: "E.g Physics book Pg 345 Ex 12-45",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          _buildDueDateSection(),
          RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            textColor: Colors.white,
            label: Text("ADD TODO"),
            icon: Icon(Icons.add),
            onPressed: () =>
              addNewTodoItem(
                _titleEditingController.text,
                _detailsEditingController.text,
              ),
          ),
        ],
      ),
    );
  }

  /// Returns the dueDate selector widget.
  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Due Date",
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          child: DateTimeItem(
            dateTime: _dueDate,
            onChanged: (DateTime value) =>
              setState(() => _dueDate = value),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0)),
      ],
    );
  }

  /// Add a toDoItem to the database and [todoItemList].
  void addNewTodoItem( String title, String details) async {
    print(
        " the title is:$title \n The detail is: $details, dueDate is: $_dueDate");
    TodoItem todoItem = TodoItem(title, _dueDate.toString(), details);
    int savedItemId = await db.saveItem(todoItem);

    TodoItem addedItem = await db.getItem(savedItemId);
    setState(() =>
      todoListPagekey.currentState.todoItemList["activeTodoItems"]
        .insert(0, addedItem)
    );

    print("Item saved with id: $savedItemId");
    Navigator.of(context).pop();
    Scaffold
    .of(widget._scaffoldContext) //TODO This line throws an error. Apparently context is null.
    .showSnackBar(SnackBar(
        content: Text("Task has been saved."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// If user presses the close IconButton, show a dialog to confirm whether
  /// (s)he wants to discard the new todo.
  Future<bool> showConfirmationDialog() async {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Discard new Todo?', style: dialogTextStyle),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
                onPressed: () =>
                  Navigator.of(context).pop(false
                  ) // Pops the confirmation dialog but not the tab.
            ),
            FlatButton(
              child: Text('DISCARD'),
                onPressed: () =>
                  Navigator.of(context).pop(true),
                    /// Returning true to [showConfirmationDialog] will pop again.
              ),
            ],
          );
        },
      ) ??
      false;
  }
}