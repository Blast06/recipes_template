import 'dart:core';

import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get startCooking;

  String get speak;

  String get stop;

  String get dark;

  String get light;

  String get systemDefault;

  String get passwordLengthShouldBeMoreThan;

  String get yourInterNetNotWorking;

  String get pressBackAgainToExitApp;

  String get updateUtensil;

  String get updateIngredients;

  String get recipeUpdate;

  String get yes;

  String get dishTypeData;

  String get cuisineData;

  String get ingredientUpdate;

  String get slider;

  String get profileUpdateSuccessfully;

  String get signUpToYourAccount;

  String get loginToYourAccount;

  String get loginWithAdminDemo;

  String get orLoginWithGoogle;

  String get emptySliderData;

  String get updateSlider;

  String get areYouSureRemoveThisSlider;

  String get sliderRemove;

  String get title;

  String get description;

  String get addSlider;

  String get addSliderSucessfully;

  String get demoUserMsg;

  String get deleteUtensil;

  String get addUtensil;

  String get egOriginalRecipe;

  String get addAUtensil;

  String get clickYourList;

  String get ingredientUsed;

  String get stepDescription;

  String get pleaseSelectImage;

  String get stepUpdateSuccessfully;

  String get stepSaveSuccessfully;

  String get deleteThisRecipeStep;

  String get deleteThisStep;

  String get deleteThisIngredient;

  String get ratingDeletedSuccessfully;

  String get doYouDeleteYourRating;

  String get addUtensilBakingDish;

  String get egBreakfast;

  String get restingTime;

  String get bakingTime;

  String get preTimeCookingTime;

  String get done;

  String get minutes;

  String get hours;

  String get name;

  String get dateOfBirth;

  String get male;

  String get female;

  String get edit;

  String get deleteThisRecipe;

  String get deletedRecipeSuccessfully;

  String get publishSuccessfully;

  String get addAnIngredient;

  String get pleaseEnterTheValue;

  String get signInYourselfToStarted;

  String get shoppingListTodo;

  String get removeThisRecipe;

  String get eg52;

  String get addIngredientFlour;

  String get egCapsule;

  String get egFlourAndIngredients;

  String get update;

  String get recipeSaved;

  String get delete;

  String get recipeDeleted;

  String get additionalComments;

  String get review;

  String get adminSetting;

  String get dishType;

  String get cuisine;

  String get purchase;

  String get contactUs;

  String get language;

  String get version;

  String get easilyPrepare;

  String get navigate;

  String get makeYourLife;

  String get skip;

  String get next;

  String get getStarted;

  String get email;

  String get password;

  String get signIn;

  String get alreadyHaveAnAccount;

  String get signUp;

  String get registerYourSelf;

  String get userName;

  String get fullName;

  String get confirmPassword;

  String get thisFieldIsRequired;

  String get passwordDoesNotMatch;

  String get forgotPassword;

  String get sendYourPassword;

  String get editProfile;

  String get bio;

  String get gender;

  String get save;

  String get pleaseSelectYourProfileImage;

  String get changePassword;

  String get oldPassword;

  String get newPassword;

  String get notMatchPassword;

  String get home;

  String get search;

  String get create;

  String get shoppingList;

  String get noDataFound;

  String get latestRecipes;

  String get viewAll;

  String get recipeSearch;

  String get emptyShoppingList;

  String get sureYouWantToRemove;

  String get profile;

  String get published;

  String get drafts;

  String get bookmark;

  String get setting;

  String get selectTheme;

  String get privacyPolicy;

  String get helpSupport;

  String get termsCondition;

  String get shareApp;

  String get about;

  String get login;

  String get logout;

  String get doYouWantToLogout;

  String get addDishType;

  String get egSnack;

  String get cancel;

  String get ok;

  String get categorySuccessfully;

  String get removeThisCategory;

  String get deletedSuccessfully;

  String get addCuisine;

  String get egChinese;

  String get sureYouWantCuisine;

  String get cuisineHasBeenDeletedSuccessfully;

  String get ourLatestRecipes;

  String get tooFewRating;

  String get difficulty;

  String get cookingPreparation;

  String get baking;

  String get resting;

  String get ingredients;

  String get remove;

  String get removedShoppingList;

  String get view;

  String get addToShoppingList;

  String get addedShoppingList;

  String get utensil;

  String get viewComments;

  String get comments;

  String get noComments;

  String get ratingHasBeenSaveSuccessfully;

  String get recipeReview;

  String get submitReview;

  String get pleaseSubmitYourReview;

  String get yourRecipeIsNotSavedYet;

  String get okGoBack;

  String get newRecipe;

  String get nameYourRecipe;

  String get egVegetarian;

  String get addRecipePhoto;

  String get changeImage;

  String get pleaseEnterRecipeName;

  String get pleaseRecipeImage;

  String get portionType;

  String get choiceBetweenServing;

  String get howMakingTheDish;

  String get howBakeFor;

  String get doesTheAnyPoint;

  String get pleaseAddPortionUnit;

  String get pleaseAddPreparationTime;

  String get pleaseEnterDishType;

  String get pleaseEnterCuisine;

  String get addIngredient;

  String get specialUse;

  String get amount;

  String get unit;

  String get pleaseEnterTheIngredients;

  String get steps;

  String get addAStep;

  String get recipePublish;

  String get publish;

  String get saveDraft;

  String get stepPhoto;

  String get sliderHasBeenUpdatedSuccessfully;

  String get sliderHasBeenSaveSuccessfully;

  String get unpublished;

  String get no;

  String get recipeUnPublishedSucessfully;

  String get addRecipe;

  String get unpublishedThisRecipe;

  String get pleaseEnterIngredientAmount;

  String get pleaseEnterIngredientUnit;

  String get lblWriteMsg;

  String get step1Title;

  String get step2Title;

  String get step3Title;

  String get step4Title;

  String get deleteImageTitle;

  String get filterBy;

  String get apply;

  String get clearFilter;

  String get step;

  String get corfirmAppCloseMsg;

  String get walkthrough1Title;

  String get walkthrough1SubTitle;

  String get walkthrough2Title;

  String get walkthrough2SubTitle;
}
