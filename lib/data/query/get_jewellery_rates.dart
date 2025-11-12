import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jjewellery/endpoints.dart';

import '../../main_common.dart';
import '../../models/rates.dart';

class GetJewelleryRates {
  Dio dio = Dio();
  static Rates rates = Rates(
    serverId: "69",
    englishDate: "2025-01-27 12:37:26",
    gold: "160100",
    silver: "1800",
    goldDiff: "0",
    silverDiff: "0",
    nepaliDate: "2081-Magh-14",
  );

  Future<Rates> requestRatesFromServer({bool forceRefresh = false}) async {
    // If forceRefresh is true OR rates is empty, make a new API call
    if (forceRefresh || rates.gold == '0') {
      late Response response;
      try {
        response = await dio.get(Endpoints.jewelleryRateUrl);
      } on DioException {
        return GetJewelleryRates.rates;
      } catch (e) {
        return GetJewelleryRates.rates;
      }

      List decodedResponse = jsonDecode(response.data) as List;

      rates = Rates(
        serverId: decodedResponse[0]['id'].toString(),
        nepaliDate: decodedResponse[0]['rate_date'].toString(),
        gold: decodedResponse[0]['gold_rate'].toString(),
        silver: decodedResponse[0]['silver_rate'].toString(),
        englishDate: decodedResponse[0]['date_ad'].toString(),
        goldDiff: decodedResponse[0]['goldDiff'].toString(),
        silverDiff: decodedResponse[0]['silverDiff'].toString(),
      );
      var latestRates = await db.rawQuery("SELECT * FROM RATES");

      if (latestRates.isNotEmpty) {
        for (int i = 0; i < decodedResponse.length; i++) {
          await db.rawUpdate(
              "UPDATE RATES SET serverID=?,eng_date=?,nep_date=?,gold=?,silver=?,gold_diff=?,silver_diff=? WHERE id=?",
              [
                decodedResponse[i]['id'].toString(),
                decodedResponse[i]['date_ad'].toString(),
                decodedResponse[i]['rate_date'].toString(),
                decodedResponse[i]['gold_rate'].toString(),
                decodedResponse[i]['silver_rate'].toString(),
                decodedResponse[i]['goldDiff'].toString(),
                decodedResponse[i]['silverDiff'].toString(),
                i + 1,
              ]);
        }
      } else {
        for (int i = 0; i < decodedResponse.length; i++) {
          await db.rawInsert(
              "INSERT INTO RATES(serverID,eng_date,nep_date,gold,silver,gold_diff,silver_diff) VALUES(?,?,?,?,?,?,?)",
              [
                decodedResponse[i]['id'].toString(),
                decodedResponse[i]['date_ad'].toString(),
                decodedResponse[i]['rate_date'].toString(),
                decodedResponse[i]['gold_rate'].toString(),
                decodedResponse[i]['silver_rate'].toString(),
                decodedResponse[i]['goldDiff'].toString(),
                decodedResponse[i]['silverDiff'].toString(),
              ]);
        }
      }
    }

    // Return the rates (either new or cached)
    return rates;
  }
}
