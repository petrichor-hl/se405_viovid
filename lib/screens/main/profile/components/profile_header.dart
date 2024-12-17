import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final userProfile = context.read<UserProfileCubit>().state.userProfile;

    return userProfile != null
        ? Column(
            spacing: 14,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: CachedNetworkImage(
                    imageUrl: '${userProfile.avatar}?t=${DateTime.now()}',
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
              Text(
                '${userProfile.name}\n${userProfile.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  userProfile.planName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(16),
            ],
          )
        : const Text(
            'Có lỗi xảy ra!!!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
