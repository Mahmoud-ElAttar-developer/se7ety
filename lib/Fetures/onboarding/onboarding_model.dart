class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingModel> model = [
  OnBoardingModel(
    image: 'assets/984946_269.svg',
    title: 'أهلا بك في التطبيق',
    description:
        'صحتك التطبيق الخاص بك للتعامل مع التخصصات الطبية والمستشفيات',
  ),
  OnBoardingModel(
    image: 'assets/984947_270.svg',
    title: 'جميع التخصصات في مكان واحد',
    description:
        'بأحدث التقنيات الطبية في مكان واحد للتعامل مع التخصصات الطبية',
  ),
  OnBoardingModel(
    image: 'assets/7774236_3736756.svg',
    title: 'اخصائيين و أستشاريين',
    description:
        'أختار طبيبك الخاص فى جميع المحافظات والمدن',
  )];