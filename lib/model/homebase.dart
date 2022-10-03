class HomeBase{
  String base_name;
  String address;
  String about;
  List<List<double>> base_polygon;


  HomeBase({
    required this.base_name,
    required this.address,
    required this.about,
    required this.base_polygon
  });
}


List<HomeBase> ListHomeBases = [
  HomeBase(
    base_name: "Ruxne Home",
    address : "Jalan Pangeran Hidayatullah Samarinda",
    about : "Homebase ruxne",
    base_polygon: [
      [-0.5001439451537939, 117.15354726979075],
      [-0.5001928936022342, 117.15370149679941],
      [-0.5003269989385367, 117.15366260477111],
      [-0.5002907904980081, 117.1535097188669],
    ]
  ),
  HomeBase(
    base_name: "KOS",
    address : "Jalan Pangeran Hidayatullah Samarinda",
    about : "Homebase ruxne",
    base_polygon: [
      [-1.1451785915814243, 116.87968230898903],
      [-1.1459187333010759, 116.87966353352729],
      [-1.1459455500266806, 116.88039577658884],
      [-1.1451517748535167, 116.88041723425961],
    ]
  ),
  HomeBase(
    base_name: "ITK",
    address : "ITK KARANG JOANG",
    about : "ITK GG GAMINK",
    base_polygon: [
      [-1.1507875572101527, 116.86368725218014],
      [-1.1509116281336917, 116.86027875006833],
      [-1.1483392232156804, 116.86046075746269],
      [-1.1483557660199941, 116.86427463967999],
    ]
  ),
  HomeBase(
    base_name: "Lab",
    address : "Lab ITK",
    about : "Lab Terpadu",
    base_polygon: [
      [-1.1492653898565148, 116.86332341194709],
      [-1.1486240064618658, 116.86363996313686],
      [-1.148436289555679, 116.86268509678767],
      [-1.1488868101097975, 116.86237396056157],
    ]
  ),
];

