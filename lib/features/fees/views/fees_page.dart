import 'package:academia/features/fees/service/fees_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final FeesService _feesService = FeesService();

  List<Map<String, dynamic>> transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchFeesTransactions();
  }

  Future<void> fetchFeesTransactions() async {
    final feesResult = await _feesService.fetchFeesTransactions();
    _isLoading = false;
    feesResult.fold((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }, (txns) {
      transactions.clear();
      transactions.addAll(txns);
      transactions = transactions.reversed.toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchFeesTransactions();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "assets/images/fees.jpg",
                  fit: BoxFit.fill,
                ),
                title: Text("School fees"),
              ),
            ),
            transactions.isNotEmpty
                ? SliverPinnedHeader(
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        leading: Icon(Clarity.coin_bag_solid),
                        title: Text(
                          transactions.first['running_balance'].trim(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: (transactions.first["running_balance"]
                                            as String)
                                        .contains('-')
                                    ? Colors.green
                                    : Colors.red,
                              ),
                        ),
                        subtitle: Text(
                          "Your current running balance",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(),
            _isLoading
                ? MultiSliver(children: [
                    Lottie.asset(
                      "assets/lotties/fetching.json",
                      height: 200,
                    ),
                    SizedBox(height: 22),
                    Text(
                      "Hang on tight as we fetch your fees transactions",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ])
                : transactions.isEmpty
                    ? MultiSliver(
                        children: [
                          Lottie.asset(
                            "assets/lotties/bunny.json",
                            height: 200,
                          ),
                          SizedBox(height: 22),
                          Text(
                            "Oops seems you have no transactions to display yet",
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : SliverList.builder(
                        itemBuilder: (context, index) {
                          final txn = transactions.elementAt(index);
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(index.toString()),
                            ),
                            title: Text(txn["ref"].toString().trim()),
                            subtitle: Text(
                                "${txn["description"].trim()}\nDebit: ${txn['debit'].trim()} Credit: ${txn['credit'].trim()} Balance: ${txn['running_balance'].trim()}\n${txn['posting_date'].trim()}"),
                            subtitleTextStyle:
                                Theme.of(context).textTheme.bodySmall,
                            isThreeLine: true,
                          );
                        },
                        itemCount: transactions.length,
                      )
          ],
        ),
      ),
    );
  }
}
