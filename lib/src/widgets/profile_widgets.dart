import 'package:flutter/material.dart';
import'package:hedieaty/src/utils/constants.dart';

Widget buildActionButton(
    BuildContext context, {
      required String label,
      required Color color,
      required Color textColor,
      required VoidCallback onPressed,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextButton(
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.2,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: 20),
          ),
        ),
      ),
      onPressed: onPressed,
    ),
  );
}

Widget buildInfoCard(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        color: christmasWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    ),
  );
}



class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
        required this.icon,
        this.onPressed,
        this.subTitle = '',
        required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: christmasYellow,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
                color: christmasYellow, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: christmasYellow,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class AppbarBackButton extends StatelessWidget {
  const AppbarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
