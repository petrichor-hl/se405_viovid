import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:viovid_app/base/components/single_child_scroll_view_with_column.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/person_detail/cubit/person_detail_cubit.dart';
import 'package:viovid_app/features/person_detail/dtos/person.dart';

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({
    super.key,
    required this.personId,
  });

  final String personId;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PersonDetailCubit>().getPersonDetail(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    final personDetailState = context.watch<PersonDetailCubit>().state;

    var personDetailWidget = (switch (personDetailState) {
      PersonDetailInProgress() => _buildInProgressPersonDetailWidget(),
      PersonDetailSuccess() =>
        _buildPersonDetailWidget(personDetailState.person),
      PersonDetailFailure() =>
        _buildFailurePersonDetailWidget(personDetailState.message),
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollViewWithColumn(
        // padding: const EdgeInsets.symmetric(horizontal: 14),
        child: personDetailWidget,
      ),
    );
  }

  Widget _buildInProgressPersonDetailWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: Row(
            children: [
              SkeletonLoading(
                height: 240,
                width: 160,
              ),
              SizedBox(
                width: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoading(height: 40, width: 100),
                  SkeletonLoading(height: 40, width: 150),
                  SkeletonLoading(height: 40, width: 80),
                  SkeletonLoading(height: 40, width: 110),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        SkeletonLoading(height: 26, width: 80),
        SizedBox(
          height: 4,
        ),
        SkeletonLoading(height: 210, width: double.infinity),
      ],
    );
  }

  Widget _buildPersonDetailWidget(Person person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 240,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                child: person.profilePath != null
                    ? Image.network(
                        person.profilePath!,
                        width: 160,
                      )
                    : const SizedBox(
                        width: 160,
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tên',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        person.name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày sinh',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        person.dob == null
                            ? '-'
                            : '${DateFormat('dd-MM-yyyy').format(person.dob!)} (${calculateAgeFrom(person.dob!)} tuổi)',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giới tính',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        person.gender == 0 ? 'Nam' : 'Nữ',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nghề nghiệp',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        person.knownForDepartment,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Tiểu sử',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        person.biography == null
            ? const Text(
                '-',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : ReadMoreText(
                '${person.biography}   ',
                trimLines: 10,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Xem thêm',
                trimExpandedText: 'Ẩn bớt',
                style: const TextStyle(
                  color: Colors.white,
                ),
                moreStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                lessStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
        const SizedBox(height: 16),
        const Text(
          'Tuyển tập',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8),
          children: List.generate(
            person.films.length,
            (index) {
              return InkWell(
                onTap: () => context.push(
                  RouteName.filmDetail
                      .replaceFirst(':id', person.films[index].filmId),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    person.films[index].posterPath,
                  ),
                ).animate().fade().scale(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFailurePersonDetailWidget(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Có lỗi xảy ra:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  int calculateAgeFrom(DateTime birthday) {
    final currentDate = DateTime.now();
    int age = DateTime.now().year - birthday.year;

    // Adjust the age if the birthdate hasn't occurred yet this year
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }

    return age;
  }
}
