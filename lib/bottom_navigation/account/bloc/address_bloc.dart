import 'package:bloc/bloc.dart';
import 'package:courierone/home_repository.dart';
import 'package:courierone/models/address/getaddress_json.dart';

import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  HomeRepository _repository = HomeRepository();

  AddressBloc() : super(LoadingAddressState());

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    if (event is FetchAddressesEvent) {
      yield* _mapFetchAddressesToState();
    }
  }

  Stream<AddressState> _mapFetchAddressesToState() async* {
    LoadingAddressState();
    try {
      List<GetAddress> listOfAddresses = await _repository.getAddress();
      // UserInformation userInformation = await _userRepository.getData();
      yield SuccessAddressState(listOfAddresses);
    } catch (e) {
      throw FailureAddressState(e);
    }
  }
}
