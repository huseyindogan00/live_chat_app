
/* class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  late final UserViewModel _userViewModel;
  late final bool _isTalks;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey2 = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _userViewModel = widget.userViewModel;
    _isTalks = widget.isTalks;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(),
    );
  }
} */


/* FutureBuilder<List<UserModel>>(
        future: _isTalks
            ? _userViewModel.fetchChattedUsers(_userViewModel.userModel!.userID!)
            : _userViewModel.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<UserModel>? users = snapshot.data;
              return _buildUserListBuilder(users);
            } else {
              return _buildIsUserNull(context);
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      )

RefreshIndicator _buildUserListBuilder(List<UserModel>? users) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        setState(() {});
      },
      child: ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          if (_userViewModel.userModel!.userID != users[index].userID) {
            return _buildUserCard(context, users[index]);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
 
 

  // hiç bir kullanıcı bulunamadığında
  RefreshIndicator _buildIsUserNull(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey2,
      onRefresh: () async {
        setState(() {});
      },
      child: Stack(
        children: [
          ListView(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            const Center(child: Text('Kayıtlı kullanıcı yoktur'))
          ]),
        ],
      ),
    );
  } */