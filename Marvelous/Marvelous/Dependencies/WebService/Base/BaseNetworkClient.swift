//
//  WebService .swift
//  CryptoList
//
//  Created by Martin Dimitrov on 29.01.22.
//

import Alamofire
import Combine

class BaseNetworkClient {
	private let session = Session()

	public func request<P: Encodable, T: Decodable>(url: String,
													method: HTTPMethod,
													parameters: P? = nil,
													encoder: ParameterEncoder = .urlEncodedForm(),
													decoder: JSONDecoder = JSONDecoder(),
													headers: HTTPHeaders? = nil,
													appendBaseUrl: Bool = true) -> AnyPublisher<T, Error> {
		let request: AnyPublisher<DataResponse<T, Error>, Never> = requestDataResponse(url: url,
																					   method: method,
																					   parameters: parameters,
																					   encoder: encoder,
																					   decoder: decoder,
																					   headers: headers,
																					   appendBaseUrl: appendBaseUrl)
		return request.tryCompactMap { res -> T? in
			if let error = res.error {
				throw error
			}

			return res.value
		}.eraseToAnyPublisher()
	}

	public func request<T: Decodable>(url: String,
									  method: HTTPMethod,
									  decoder: JSONDecoder = JSONDecoder(),
									  headers: HTTPHeaders? = nil,
									  appendBaseUrl: Bool = true) -> AnyPublisher<T, Error> {
		let request: AnyPublisher<DataResponse<T, Error>, Never> = requestDataResponse(url: url,
																					   method: method,
																					   decoder: decoder,
																					   headers: headers,
																					   appendBaseUrl: appendBaseUrl)
		return request.tryCompactMap { res -> T? in
			if let error = res.error {
				throw error
			}

			return res.value
		}.eraseToAnyPublisher()
	}

	private func requestDataResponse<P: Encodable, T: Decodable>(url: String,
																 method: HTTPMethod,
																 parameters: P? = nil,
																 encoder: ParameterEncoder,
																 decoder: JSONDecoder = JSONDecoder(),
																 headers: HTTPHeaders? = nil,
																 appendBaseUrl: Bool = true) -> AnyPublisher<DataResponse<T, Error>, Never> {
		let absoluteUrl = appendBaseUrl ? url : url

		return session
			.request(absoluteUrl,
					 method: method,
					 parameters: parameters,
					 encoder: encoder,
					 headers: headers)
			.validate()
			.publishDecodable(type: T.self, decoder: decoder)
			.compactMap { [weak self] response in
				self?.tryDecodingError(response: response, decoder: decoder)
			}.eraseToAnyPublisher()
	}

	public func requestDataResponse<T: Decodable>(url: String,
												  method: HTTPMethod,
												  decoder: JSONDecoder = JSONDecoder(),
												  headers: HTTPHeaders? = nil,
												  appendBaseUrl: Bool = true) -> AnyPublisher<DataResponse<T, Error>, Never> {
		let absoluteUrl = appendBaseUrl ? url : url

		return session
			.request(absoluteUrl,
					 method: method,
					 headers: headers)
			.validate()
			.publishDecodable(type: T.self, decoder: decoder)
			.compactMap { [weak self] response in
				self?.tryDecodingError(response: response, decoder: decoder)
			}.eraseToAnyPublisher()
	}

	private func tryDecodingError<T: Decodable>(response: DataResponsePublisher<T>.Output,
												decoder: JSONDecoder) -> DataResponse<T, Error> {
		let res = response.mapError { [weak self] error -> Error in

			if let data = response.data,
			   let decodedRemoteError = self?.decodeRemoteError(decoder: decoder, data: data) {
				return decodedRemoteError
			}

			return error
		}
		return res
	}

	private func decodeRemoteError(decoder: JSONDecoder, data: Data) -> WebError? {
		let decodedError = try? decoder.decode(WebError.self, from: data)
		return decodedError
	}
}
