/*
 * (C) Copyright IBM Corporation 2019, 2020
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ibm.controllers;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.ibm.beans.ImgDetail;
import com.ibm.beans.Text;

import com.ibm.cloud.sdk.core.security.Authenticator;
import com.ibm.cloud.sdk.core.security.IamAuthenticator;

import com.ibm.watson.text_to_speech.v1.TextToSpeech;
import com.ibm.watson.text_to_speech.v1.model.SynthesizeOptions;
import com.ibm.watson.text_to_speech.v1.util.WaveUtils;

//import com.ibm.watson.developer_cloud.visual_recognition.v3.VisualRecognition;
//import com.ibm.watson.developer_cloud.visual_recognition.v3.model.DetectedFaces;
//import com.ibm.watson.developer_cloud.visual_recognition.v3.model.VisualRecognitionOptions;

import org.springframework.ui.ModelMap;

@Controller
public class ImgController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "index";
	}
	
	@RequestMapping(value = "/image", method = RequestMethod.GET)
	public ModelAndView image() {
		return new ModelAndView("imageHome", "command", new ImgDetail());
	}

	//@RequestMapping(value = "/imageprocess", method = RequestMethod.POST)
	//public ModelAndView processimage(@ModelAttribute("SpringWeb") ImgDetail img) {
	//	try{
	//	System.out.println(img.getUrl());
	//	String vrAuthToken = System.getenv("VISUAL_RECOGNITION_IAM_APIKEY");
	//	VisualRecognition service = new VisualRecognition(vrAuthToken);

	//	System.out.println("Detect faces");
	//	VisualRecognitionOptions options = new VisualRecognitionOptions.Builder().url(img.getUrl()).build();
	//	DetectedFaces result = service.detectFaces(options).execute();
	//	System.out.println(result);

	//	JsonObject rawOutput = new JsonParser().parse(result.toString()).getAsJsonObject();
	//	JsonObject face = rawOutput.get("images").getAsJsonArray().get(0).getAsJsonObject().get("faces")
	//			.getAsJsonArray().get(0).getAsJsonObject();

	//	if (face.get("identity") == null)
	//		img.setName("Cannot be identified");
	//	else
	//		img.setName(face.get("identity").getAsJsonObject().get("name").getAsString());

	//	if (face.get("gender") == null)
	//		img.setGender("Cannot be identified");
	//	else
	//		img.setGender(face.get("gender").getAsJsonObject().get("gender").getAsString());

	//	if (face.get("age").getAsJsonObject().get("min") == null)
	//		img.setMin_age("NA");
	//	else
	//		img.setMin_age(face.get("age").getAsJsonObject().get("min").getAsString());

	//	if (face.get("age").getAsJsonObject().get("max") == null)
	//		img.setMax_age("NA");
	//	else
	//		img.setMax_age(face.get("age").getAsJsonObject().get("max").getAsString());

	//	return new ModelAndView("result", "img", img);
	//	}
	//	catch(Exception e){
	//		e.printStackTrace();
	//		return new ModelAndView("error"); 
	//	}

	//}

	@RequestMapping(value = "/text", method = RequestMethod.GET)
	public ModelAndView text() {
		return new ModelAndView("textHome", "command", new Text());
	}

	@RequestMapping(value = "/textprocess", method = RequestMethod.GET)
	public void texttospeech(@ModelAttribute("Spring") Text txt, HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		String ttsAuthToken = removeLastCharacter(System.getenv("TEXT_TO_SPEECH_IAM_APIKEY"));
		System.out.println("TEXT_TO_SPEECH_IAM_APIKEY Value:- " + ttsAuthToken);
		Authenticator ttsAuthenticator = new IamAuthenticator(ttsAuthToken);
		TextToSpeech synthesizer = new TextToSpeech(ttsAuthenticator);

		try {

			String text = request.getParameter("text");
			
			SynthesizeOptions synthesizeOptions = new SynthesizeOptions.Builder()
				.text(text)
				.voice(SynthesizeOptions.Voice.EN_US_LISAVOICE)
				.accept("audio/wav")
				.build();
			InputStream in = synthesizer.synthesize(synthesizeOptions).execute().getResult();

			if (request.getParameter("download") != null) {
				response.setHeader("content-disposition", "attachment; filename=audio.wav");
			}
			OutputStream out = response.getOutputStream();
			byte[] buffer = new byte[1024];
			int length;
			while ((length = in.read(buffer)) > 0) {
				out.write(buffer, 0, length);
			}
			out.close();
			in.close();
			System.out.println("done");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	public static String removeLastCharacter(String str) {
		String result = null;
		if ((str != null) && (str.length() > 0)) {
			result = str.substring(0, str.length() - 1);
		}
		return result;
	}
}
