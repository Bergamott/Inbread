//
//  EasingDeclarations.h
//  AHEasing
//
//  Created by Warren Moore on 1/16/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.
//
//  See LICENSE file for licensing information
//

typedef NS_ENUM(NSInteger, CurveType)
{
	CurveTypeLinear,
	CurveTypeQuadratic,
	CurveTypeCubic,
	CurveTypeQuartic,
	CurveTypeQuintic,
	CurveTypeSine,
	CurveTypeCircular,
	CurveTypeExpo,
	CurveTypeElastic,
	CurveTypeBack,
	CurveTypeBounce,
    CurveTypeCartoony,
};

typedef NS_ENUM(NSInteger, EasingMode)
{
	EaseIn,
	EaseOut,
	EaseInOut,
};
