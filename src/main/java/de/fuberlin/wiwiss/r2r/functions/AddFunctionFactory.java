/*
 *  R2R
 *
 *  Copyright 2010-2011 Freie Universität Berlin
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package de.fuberlin.wiwiss.r2r.functions;

import java.util.ArrayList;
import java.util.List;
import java.math.BigInteger;
import java.math.BigDecimal;

import de.fuberlin.wiwiss.r2r.Function;
import de.fuberlin.wiwiss.r2r.FunctionFactory;

import de.fuberlin.wiwiss.r2r.functions.HelperFunctions.DataType;

public class AddFunctionFactory implements FunctionFactory {
	private AddFunction function = null;
	
	public Function getInstance() {
		if(function==null)
			function = new AddFunction();
		
		return function;
	}

	private static class AddFunction implements Function {

		public String getURI() {
			return "add";
		}
		
		public List<String> execute(List<List<String>> arguments, String hint) {
			if(arguments.size()<1)
				throw new IllegalArgumentException("Add: No arguments supplied!");
			
			List<String> result = new ArrayList<String>();
			DataType type = HelperFunctions.getDataTypeInformationOfAllArguments(arguments);
			type = HelperFunctions.takeMostAppropriateDataTypeForAddLikeCalculations(type, hint);
			
			if(type==DataType.String)
				throw new IllegalArgumentException("Non-numerical argument for add-function");
			if(type==DataType.Int) {
				Integer intResult = 0;
				for(List<String> argument: arguments)
					intResult += Integer.parseInt(argument.get(0));
				result.add(intResult.toString());
			} else if(type==DataType.Long) {
				Long longResult = 0l;
				for(List<String> argument: arguments)
					longResult += Long.parseLong(argument.get(0));
				result.add(longResult.toString());
			} else if(type==DataType.Integer) {
				BigInteger bigIntResult = BigInteger.ZERO;
				for(List<String> argument: arguments)
					bigIntResult = bigIntResult.add(new BigInteger(argument.get(0)));
				result.add(bigIntResult.toString());
			} else if(type==DataType.Decimal) {
				BigDecimal decimalResult = BigDecimal.ZERO;
				boolean first = true;
				for(List<String> argument: arguments)
					if(first)
						decimalResult = new BigDecimal(argument.get(0));
					else
						decimalResult = decimalResult.add(new BigDecimal(argument.get(0)));
				result.add(decimalResult.toString());
			} else if(type==DataType.Double) {
				Double doubleResult = 0.0;
				for(List<String> argument: arguments)
					doubleResult += Double.parseDouble(argument.get(0));
				result.add(doubleResult.toString());
			}

			return result;
		}
	}
}
