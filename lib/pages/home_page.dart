import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/todo_bloc.dart';
import 'package:task/pages/detail_page.dart';
import 'package:task/widget/loading_widget.dart';
import 'package:task/widget/todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoBloc _bloc = TodoBloc();

  @override
  void initState() {
    _bloc.add(FetchAllTodoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Todo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider<TodoBloc>(
        create: (_) => _bloc,
        child: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoInitial) {
                return const LoadingWidget();
              } else if (state is TodoLoading) {
                return const LoadingWidget();
              } else if (state is TodoLoaded) {
                return _TodoListContent(state: state);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _TodoListContent extends StatelessWidget {
  const _TodoListContent({required this.state});
  final TodoLoaded state;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      itemBuilder: (_, index) {
        return TodoCardWidget(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(model: state.result[index]),
            ),
          ),
          index: index,
          model: state.result[index],
        );
      },
      separatorBuilder: (_, index) => const SizedBox(height: 15),
      itemCount: state.result.length,
    );
  }
}
