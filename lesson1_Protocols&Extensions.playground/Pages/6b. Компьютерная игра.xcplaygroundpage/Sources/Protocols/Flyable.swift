// MARK: - Flyable Protocol

/// Опсиывает набор требований для объекта, который может летать
public protocol Flyable {

	/// Метод взлета, зажигается, когда объект взлетает
	///  - Returns: Статус взлета (true, если объект взлетел)
	func takeOff() -> Bool

	/// Метод взлета, зажигается, когда объект уже летит
	///  - Returns: Контекст полета
	func fly() -> FlyingContext
	
	/// Метод посадки, зажигается, когда объект садится
	func land()

	/// Метод взлета, зажигается, когда объект сел
	///  - Returns: Статус взлета (true, если сел)
	func landed() -> Bool

}
