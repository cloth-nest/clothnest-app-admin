import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic('dns3ruxri', 'cemj3klu', cache: false);

  Future<String?> uploadImage(String path, String nameFolder) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          path,
          folder: nameFolder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }

    return null;
  }
}
