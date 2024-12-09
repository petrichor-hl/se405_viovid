import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/features/user-profile/cubit/user_profile_cutbit.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 150,
            height: 150,
            child: CachedNetworkImage(
              imageUrl:
                  '${context.read<UserProfileCubit>().state?.avatar}?t=${DateTime.now()}',
              fit: BoxFit.cover,
              // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
              fadeInDuration: const Duration(milliseconds: 400),
              // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
              fadeOutDuration: const Duration(milliseconds: 800),
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(26),
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ),
        const Gap(12),
        Text(
          '${context.read<UserProfileCubit>().state?.name}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${context.read<UserProfileCubit>().state?.email}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
