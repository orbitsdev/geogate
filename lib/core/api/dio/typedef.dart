import 'package:fpdart/fpdart.dart';
import 'package:geogate/core/shared/model/failure.dart';

typedef EitherModel<T> = Future<Either<Failure, T>>; 