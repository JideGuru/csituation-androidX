
class Validations {

  String validateDropDown(String value, String itemVal) {
    if(itemVal == null) return value == 'RT' ? 'Select the rental type' : value == 'LT' ? 'Select the laundry type' : value == 'PT' ? 'Select the parking type' : value == 'AT' ? 'Select the air conditioning type' : value == 'HT' ? 'Select the heating type' : 'Cannot be empty';
    return null;
    }

  String validateZipCode(String value) {
    if (value.isEmpty || value.length > 6 || value.length < 6) return 'Enter valid zip code';
    return null;
  }

  String validateCity(String value) {
    if(value.isEmpty) return 'Enter the city the Listing is Located';
    return null;
  }

  String validateState(String value) {
    if(value.isEmpty) return 'Enter the state the Listing is Located';
    return null;
  }

  String validateAddress(String value) {
    if(value.isEmpty) return 'Enter the listing Address';
    return null;
  }

  String validateBathroom(String value) {
    if(value.isEmpty) return 'Please enter no. of Bathroom';
    return null;
  }

  String validatePrice(String value) {
    if(value.isEmpty) return 'Please enter the listing price';
    return null;
  }

  String validateDesc(String value) {
    if(value.isEmpty) return 'Listing description can not be empty';
    if(value.length < 20) return 'Minimum of 20 characters is required for Listing description';
    return null;
  }

  String validateSize(String value) {
    if(value.isEmpty) return 'Please enter the size of the House';
    return null;
  }

  String validateBedroom(String value) {
    if(value.isEmpty) return 'Please enter no. of Bedroom';
    return null;
  }

  String validateDate(String value) {
    if(value == null) return 'Select if the crime is ongoing or past';
    return null;
  }
  String validateStoryCatDropDown(String value) {
    if(value == null) return 'Select story category';
    return null;
  }

  String validateStoryDesc(String value) {
    if(value.isEmpty) return 'Story description can not be empty';
    return null;
  }
  String validateStoryTitle(String value) {
    if(value.isEmpty) return 'Story title can not be empty';
    return null;
  }
}