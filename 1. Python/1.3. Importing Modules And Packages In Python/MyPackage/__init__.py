

'''
### `__init__.py` in Very Short

`__init__.py` is a special Python file placed inside a folder to indicate that the folder should be treated as a **package**.

### Example Structure

```text
mypackage/
│
├── __init__.py
├── module1.py
└── module2.py
```

### Uses

1. **Marks a directory as a package** (especially in older Python versions).
2. **Runs initialization code** when the package is imported.
3. Can be used to **import commonly used functions/modules automatically**.

### Example

****init**.py**

```python
print("Package loaded")
```

**main.py**

```python
import mypackage
```

**Output**

```text
Package loaded
```

### Viva Answer

**Q: What is `__init__.py`?**

**A:** `__init__.py` is a special file inside a package that is executed when the package is imported. It is used to initialize the package and organize package-level imports.



'''