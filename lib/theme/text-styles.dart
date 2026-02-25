import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ── Existing styles (keep as is) ──────────────────────────────

const bodyText1Style = TextStyle(
    fontSize: ts2,
    fontWeight: FontWeight.w600,
    color: AppColor.bodyTextColor,
    fontStyle: FontStyle.normal,
    fontFamily: 'Montserrat');

const bodyText2Style = TextStyle(
    fontSize: ts4,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyTextColor,
    fontStyle: FontStyle.normal,
    fontFamily: 'Montserrat');

const headerText1Style = TextStyle(
    fontSize: ts1,
    fontWeight: FontWeight.bold,
    color: AppColor.headerTextColor,
    fontStyle: FontStyle.normal,
    fontFamily: 'Montserrat');

const headerText2Style = TextStyle(
    fontSize: ts2,
    fontWeight: FontWeight.bold,
    color: AppColor.headerTextColor,
    fontStyle: FontStyle.normal,
    fontFamily: 'Montserrat');

const headerText3Style = TextStyle(
    fontSize: ts3,
    fontWeight: FontWeight.bold,
    color: AppColor.headerTextColor,
    fontStyle: FontStyle.normal,
    fontFamily: 'Montserrat');

// ── New brand styles ───────────────────────────────────────────

// Large display — product title, hero text
const displayStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: brandTextPrimary,
    height: 1.2,
    letterSpacing: -0.3,
    fontFamily: 'Montserrat');

// Price — big bold number
const priceStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: brandPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Montserrat');

// Price — original strikethrough
const priceStrikeStyle = TextStyle(
    fontSize: 15,
    color: brandTextSecondary,
    decoration: TextDecoration.lineThrough,
    fontFamily: 'Montserrat');

// Section headers e.g. "Description", "Reviews"
const sectionTitleStyle = TextStyle(
    fontSize: ts3,
    fontWeight: FontWeight.w800,
    color: brandTextPrimary,
    fontFamily: 'Montserrat');

// Body text — paragraphs, descriptions
const bodyStyle = TextStyle(
    fontSize: ts3,
    fontWeight: FontWeight.w400,
    color: brandTextSecondary,
    height: 1.6,
    fontFamily: 'Montserrat');

// Small muted label e.g. "(3 reviews)", "by Brand"
const captionStyle = TextStyle(
    fontSize: ts4, color: brandTextSecondary, fontFamily: 'Montserrat');

// Category label — amber all-caps
const categoryLabelStyle = TextStyle(
    fontSize: ts5,
    fontWeight: FontWeight.w700,
    color: brandAccent,
    letterSpacing: 1.5,
    fontFamily: 'Montserrat');

// Chip / badge text
const badgeStyle = TextStyle(
    fontSize: ts6,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    fontFamily: 'Montserrat');

// Button label
const buttonStyle = TextStyle(
    fontSize: ts3,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Montserrat');

// Reviewer name
const reviewerNameStyle = TextStyle(
    fontSize: ts4,
    fontWeight: FontWeight.w700,
    color: brandTextPrimary,
    fontFamily: 'Montserrat');

// Review body
const reviewBodyStyle = TextStyle(
    fontSize: ts4,
    color: brandTextSecondary,
    height: 1.5,
    fontFamily: 'Montserrat');

// Info card title (tiny muted)
const infoCardTitleStyle = TextStyle(
    fontSize: ts6,
    fontWeight: FontWeight.w700,
    color: brandTextSecondary,
    letterSpacing: 0.5,
    fontFamily: 'Montserrat');

// Info card value
const infoCardValueStyle = TextStyle(
    fontSize: ts6,
    fontWeight: FontWeight.w600,
    color: brandTextPrimary,
    fontFamily: 'Montserrat');

// Tag pill text
const tagStyle = TextStyle(
    fontSize: 11,
    color: brandPrimary,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat');

// App brand name
const brandNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: brandPrimary,
    letterSpacing: 2.5,
    fontFamily: 'Montserrat');

// App brand subtitle
const brandSubtitleStyle = TextStyle(
    fontSize: ts5,
    fontWeight: FontWeight.w600,
    color: brandAccent,
    letterSpacing: 0.5,
    fontFamily: 'Montserrat');

// Quantity number
const quantityStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: brandTextPrimary,
    fontFamily: 'Montserrat');

// Stock warning
const stockWarningStyle = TextStyle(
    fontSize: 11,
    color: brandRed,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat');

const stockSafeStyle = TextStyle(
    fontSize: 11,
    color: brandTextSecondary,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat');
