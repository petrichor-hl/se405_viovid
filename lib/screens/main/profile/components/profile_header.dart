import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/data/profile_data.dart';
import 'package:viovid_app/main.dart';

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
              // imageUrl:
              //     '$baseAvatarUrl${profileData['avatar_url']}?t=${DateTime.now()}',
              imageUrl: '$baseAvatarUrl${profileData['avatar_url']}',
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
        const Text(
          'Thành viên',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Text(
          '${profileData['full_name']}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
