import 'package:recipe_app/main.dart';

const mAppName = 'Recetas Dominicanas';

const mBaseUrl = 'https://myappsapi.xyz/recetasapps/ricetta_backend/api/';


const PostsPerPage = 10;
const mAppInfo = '''$mAppName Introducing the latest, cooking recipe app for cooking enthusiasts and Youtube chefs.
    The design consistency and vivid use of UI elements makes this amazing recipe app the starting point of launching a classic food recipe mobile application. 
    Sift through a numbers of recipes, save the favorites, and browse from the mobile-friendly user interface using this Recipe mobile app. 
    Ideally created for food fanatics and at-home cooking chefs to share their mouth-watering food recipes, admin of this app is allowed to create and manage recipes efficiently. 
    With an optimized search functionality where users of this app can search for recipes, the recipe app also allows to manage shopping list with ease and comfort. 
    Besides, easy customization and responsive layouts, Recipe app is equipped with bookmark recipes as well as enable comments on recipes for better user engagement. 
    Give it a spin and a stir, and launch a modern, classic and stunning food recipe app using this Recipe App.''';
//region URLs & Keys

const iqonicURL = 'https://codecanyon.net/item/ricetta-flutter-recipe-app-with-laravel-backend/33981990?s_rank=8';
const helpSupport = 'https://wordpress.iqonic.design/docs/product/ricetta/help-and-support/';
const PrivacyPolicy = 'https://wordpress.iqonic.design/docs/product/ricetta/privacy-policy/';

const ContactPref = 'hello@iqonic.design';

const NotAuthorisedMsg = 'You are not admin';

const mAdMobAppId = 'ca-app-pub-1399327544318575~9252792385';
const mAdMobBannerId = 'ca-app-pub-1399327544318575/4738832302';
const mAdMobInterstitialId = 'ca-app-pub-1399327544318575/8573796227';

List<String> testDevices = ['551597FF6B95q52FEBB440722967BCB6F'];

//App store URL
const appStoreBaseUrl = 'https://www.apple.com/app-store/';

//region SharedPreferences Keys
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const NAME = 'NAME';
const USER_NAME = 'USERNAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_PHOTO_URL = 'USER_PHOTO_URL';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_FIRST_TIME = 'IS_FIRST_TIME';
const LOGIN_TYPE = 'LOGIN_TYPE';
const PLAYER_ID = 'PLAYER_ID';
const PHONE_NUMBER = 'PHONE_NUMBER';
const USER_CHECK = 'type';
const API_TOKEN = 'API_TOKEN';
const USER_ROLE_PREF = 'USER_ROLE_PREF';
const GENDER = 'GENDER';
const DOB = 'DOB';
const BIO = 'BIO';
const CONTACT_PREF = 'ContactPref';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_SOCIAL_LOGIN = 'IsSocialLogin';

//region LiveStream Keys
const checkMyTopics = 'checkMyTopics';
const refreshBookmark = 'refreshBookmark';
const tokenStream = 'tokenStream';
const streamNewRecipePageChange = 'streamNewRecipePageChange';
const streamRefreshRecipe = 'streamRefreshRecipe';
const streamRefreshToDo = 'streamRefreshToDo';
const streamRefreshSlider = 'streamRefreshSlider';
const streamRefreshBookMark = 'streamRefreshBookMark';
const streamRefreshRecipeData = 'streamRefreshRecipeData';
const streamRefreshRecipeIndex = 'streamRefreshRecipeIndex';
const streamRefreshLanguage = 'streamRefreshLanguage';
const streamRefreshUnPublished = 'streamRefreshUnPublished';

//recipe type
const RecipeTypeUtensils = 'utensils';
const RecipeTypeIngredients = 'ingredients';
const RecipeTypeCuisineData = 'cuisine';
const RecipeTypeCategoryData = 'category';

/* Login Type */
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'otp';
const LoginTypeApple = 'apple';

const ROLE_USER = 'user';
const ROLE_ADMIN = 'admin';
const ROLE_DEMO = 'demo_admin';

const defaultLanguage = 'en';

// enable disable Ads
const disabled_ads = false;

//images
const WalkThroughIMG1 = 'images/walk_through_1.png';
const WalkThroughIMG2 = 'images/walk_through_2.png';
const emptyData = 'images/ic_empty.png';
const loginBGImage = 'images/ic_pattern_1.png';
const loginBGImage1 = 'images/ic_pattern.png';
const CLOCKImage = 'images/clock.png';
const loginImage = 'images/ic_signIn_bg.png';
const loginImage1 = 'images/ic_signIn_bg_1.png';
const lineImage = 'images/ic_line.png';
const appLogo = 'images/app_logo.png';
const EmptySlider = 'images/ic_advertising.png';
const ChefImage = 'images/ic_chef.png';

/* Theme Mode Type */
const ThemeModeSystem = 0;
const ThemeModeLight = 1;
const ThemeModeDark = 2;

List<String> themeModeList = [language!.systemDefault, language!.light, language!.dark];

const List<String> difficulty = ['Easy', 'Medium', 'Hard'];

// type

class Types {
  static String recipe_image = 'recipe_image';
  static String step_image_gallery = 'step_image_gallery';
}
