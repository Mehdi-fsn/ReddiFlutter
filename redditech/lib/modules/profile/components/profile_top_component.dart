import 'package:flutter/material.dart';

import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/services/api/reddit_api.dart';

class ProfilTopComponent extends StatefulWidget {
  const ProfilTopComponent({Key? key}) : super(key: key);

  @override
  State<ProfilTopComponent> createState() => _ProfilTopComponentState();
}

class _ProfilTopComponentState extends State<ProfilTopComponent> {
  var _username = '';
  var _description = '';
  var _avatarUrl = '';
  var _suscribers = 0;
  var _totalKarma = 0;
  var _friends = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RedditAPI.fetchRedditUserInfo(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.secondary,
                  ),
                ),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Loading error: ${snapshot.error}'),
              );
            }

            _username = snapshot.data!['username'];
            _description = snapshot.data!['description'];
            _avatarUrl = snapshot.data!['avatarUrl'];
            _suscribers = snapshot.data!['subscribers'];
            _totalKarma = snapshot.data!['totalKarma'] ?? 0;
            _friends = snapshot.data!['friends'] ?? 0;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AvatarBannerUsernameVarInfoBloc(
                      username: _username,
                      avatarUrl: _avatarUrl,
                      totalKarma: _totalKarma,
                      suscribers: _suscribers,
                      friends: _friends,
                      description: _description),
                ],
              ),
            );
        }
      },
    );
  }
}

class AvatarBannerUsernameVarInfoBloc extends StatelessWidget {
  const AvatarBannerUsernameVarInfoBloc(
      {Key? key,
      required String? username,
      required String? avatarUrl,
      required int? totalKarma,
      required int? suscribers,
      required int? friends,
      required String? description})
      : _friends = friends,
        _suscribers = suscribers,
        _totalKarma = totalKarma,
        _avatarUrl = avatarUrl,
        _username = username,
        _description = description,
        super(key: key);

  final String? _username;
  final String? _avatarUrl;
  final int? _totalKarma;
  final int? _suscribers;
  final int? _friends;
  final String? _description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  'https://styles.redditmedia.com/t5_7wt1dz/styles/profileBanner_341ydq25s6ka1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.primary,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: (MediaQuery.of(context).size.width - 16) / 2 - 50,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Image.network(
                    _avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Center(
            child: Text(
              _username!,
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 242,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: VariousInformations(
                  totalKarma: _totalKarma,
                  suscribers: _suscribers,
                  friends: _friends),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _description!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class VariousInformations extends StatelessWidget {
  const VariousInformations(
      {Key? key,
      required int? totalKarma,
      required int? suscribers,
      required int? friends})
      : _friends = friends,
        _suscribers = suscribers,
        _totalKarma = totalKarma,
        super(key: key);

  final int? _totalKarma;
  final int? _suscribers;
  final int? _friends;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total karma',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _totalKarma.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(
          color: AppTheme.secondary,
          width: 1,
          thickness: 2,
          indent: 15,
          endIndent: 15,
        ),
        SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Suscribers',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _suscribers.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(
          color: AppTheme.secondary,
          width: 1,
          thickness: 2,
          indent: 15,
          endIndent: 15,
        ),
        SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Friends',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _friends.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
