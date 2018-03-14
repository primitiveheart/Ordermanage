package com.constant;

public enum LegendColorEnum {
	zero("#FFFFFF"),first("#B2DF8A"),second("#33A02C"),three("#FB9A99"),
	four("#E31A1C"),five("#FDBF6F"),six("#FF7F00"),senve("#CAB2D6");
	
	private String colorValue;
	LegendColorEnum(String colorValue){
		this.colorValue = colorValue;
	}
	public String getColorValue() {
		return colorValue;
	}
}