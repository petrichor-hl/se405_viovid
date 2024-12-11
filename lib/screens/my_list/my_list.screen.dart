import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách của tôi'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<MyListCubit, MyListState>(
        builder: (ctx, state) {
          if (state is MyListSuccess) {
            return GridView(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(8),
              children: List.generate(
                state.films.length,
                (index) {
                  return InkWell(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        state.films[index].posterPath,
                      ),
                    ).animate().fade().scale(),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
