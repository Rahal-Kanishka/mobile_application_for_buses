
class Driver {
  String userName;
  String name;
  int age;
  String nationality;
  String rating;
  int trips;

  Driver(Map<String, dynamic> data) {
    if (data != null) {
      this.userName = data['userName'];
      this.name = data['name'];
      this.age = data['age'] as int;
      this.nationality = data['nationality'];
      this.rating = data['rating'];
      this.trips = data['trips'] as int;
    }
  }
}