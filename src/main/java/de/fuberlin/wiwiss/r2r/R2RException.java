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
package de.fuberlin.wiwiss.r2r;

public class R2RException extends RuntimeException {

	public R2RException() {
		super();
	}

	public R2RException(String message, Throwable cause) {
		super(message, cause);
	}

	public R2RException(String message) {
		super(message);
	}

	public R2RException(Throwable cause) {
		super(cause);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
