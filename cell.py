class Cell:
    def __init__(self, x, y, type) -> None:
        """
        Initializes a cell with a type and coordinates.

        Args:
            x (int): The x coordinate of the cell.
            y (int): The y coordinate of the cell.
            type (str): The type of the cell. Can be "obstacle" or "cell.
        """
        self.x = x
        self.y = y
        self.type = type
        self.parent = None
        self.distance = 1000
        self.visited = False

    def __str__(self) -> str:
        """Returns a string representation of the cell."""
        return f"({self.x}, {self.y})"