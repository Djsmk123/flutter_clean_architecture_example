import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mvvm_movies_app/core/utli/input_converter.dart';

@GenerateMocks([])
void main(){
  late InputConverter inputConverter;
  setUp((){
    inputConverter = InputConverter();
  });
  group('stringToUnsignedInteger', (){
    test('should return an integer when the string represents an unsigned integer', () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });
     test('should return a Failure when the string is not an integer', () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
      test('should return a Failure when the string is a negative integer', () async {
        // arrange
        const str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      });


  });


}
