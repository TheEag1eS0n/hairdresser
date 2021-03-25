import 'dart:math';
import 'dart:ui';

class ArrowPath {
  static Path make({
    required Path path,
    double tipLength = 15,
    double tipAngle = pi * 0.2,
    bool isDoubleSided = false,
    bool isAdjusted = true,
  }) =>
      _make(path, tipLength, tipAngle, isDoubleSided, isAdjusted);

  static Path _make(Path path, double tipLength, double tipAngle,
      bool isDoubleSided, bool isAdjusted) {
    Offset tipVector;

    Tangent? tan;
    double adjustmentAngle = 0;
    double angle = pi - tipAngle;

    if (path.computeMetrics().length > 0) {
      PathMetric lastPathMetric = path.computeMetrics().last;

      tan = lastPathMetric.getTangentForOffset(lastPathMetric.length);

      final Offset originalPosition = tan!.position;

      if (isAdjusted && lastPathMetric.length > 10) {
        Tangent? tanBefore =
        lastPathMetric.getTangentForOffset(lastPathMetric.length - 5);
        adjustmentAngle = _getAngleBetweenVectors(tan.vector, tanBefore!.vector);
      }

      tipVector = _rotateVector(tan.vector, angle - adjustmentAngle) * tipLength;
      path.moveTo(tan.position.dx, tan.position.dy);
      path.relativeLineTo(tipVector.dx, tipVector.dy);

      tipVector = _rotateVector(tan.vector, -angle - adjustmentAngle) * tipLength;
      path.moveTo(tan.position.dx, tan.position.dy);
      path.relativeLineTo(tipVector.dx, tipVector.dy);

      path.moveTo(originalPosition.dx, originalPosition.dy);
    }

    return path;
  }

  static Offset _rotateVector(Offset vector, double angle) => Offset(
    cos(angle) * vector.dx - sin(angle) * vector.dy,
    sin(angle) * vector.dx + cos(angle) * vector.dy,
  );

  static double _getVectorsDotProduct(Offset vector1, Offset vector2) =>
      vector1.dx * vector2.dx + vector1.dy * vector2.dy;

  // Clamp to avoid rounding issues when the 2 vectors are equal.
  static double _getAngleBetweenVectors(Offset vector1, Offset vector2) =>
      acos((_getVectorsDotProduct(vector1, vector2) /
          (vector1.distance * vector2.distance))
          .clamp(-1.0, 1.0));
}
