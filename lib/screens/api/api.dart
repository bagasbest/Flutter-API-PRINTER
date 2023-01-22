import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/token.dart';

class Api {
  static const token =
      "E6dQ_ze9mSbpP1Yrsqrk3PZ9ow8IhW0XdudBdVIeJeIhT0RKFOyjSC5hpO4XU_XrbEepMuL8MnNcLUmyA-a9pp9gQrSbsUCVkt9hITOdBWLOGrETnLv6w5AFHsFdhRn4k-fEQlM5RPxy1YAf4w2WFFHpfBWcDDCzh5XIZ1obstzPiyye1SFTD13rUikEUU7c-UsubhKxz8M_DlfZao4BZ7RqmhwDUMG8bRp7WrGlBc7ON6IPMcrtc-wY7YYUkyi3dP-qRdaC3C97sRwX19sGytN1MaSV7pyT2a7nckzCXcc8rx9LR9YTyE3jZ4q_D44SUKKwT5mjCIz48X8rSSPtPt8d0ZF_Ym0v1qrCA21JPhNqpwdKbjMWXIU3fFnN2S1X3_DCC_aWTUgxxtC0hj-nE0PrIU4QRDHrWaUCIs4DlVRZnO3t5N_Gcs9AMcqx5v9-kyk0OTWYQfR4-cawG6ccvw0VezAQKEzrvWbqKryM9FE";

  static const authentication = 'https://training.bercaretail.com/erpapi/api/authenticate';
  static const getProduct = 'https://training.bercaretail.com/erpapi/api/pos/GetProduct?article=';
  static const getMemberList = 'http://training.bercaretail.com/erpapi/api/pos/Membership';
  static const getSalesman = 'https://training.bercaretail.com/erpapi/api/pos/GetSalesname';
  static const getTransRef = 'https://training.bercaretail.com/erpapi/api/pos/GetTransRef';
  static const getPaymentRef = 'https://training.bercaretail.com/erpapi/api/pos/GetPaymenRef';
  static const getPaymentMethod = 'https://training.bercaretail.com/erpapi/api/pos/GetPaymentMethod';
  static const getSalesOrderNumber = 'https://training.bercaretail.com/erpapi/api/pos/GetSales?site=';
  static const getBanks = 'https://training.bercaretail.com/erpapi/api/pos/GetBanks';
  static const getAllCardBank = 'https://training.bercaretail.com/erpapi/api/pos/GetCardPay';
  static const getMemberWithNumber = 'https://training.bercaretail.com/erpapi/api/Article/MembershipWithNo?MobileNumber=';
}