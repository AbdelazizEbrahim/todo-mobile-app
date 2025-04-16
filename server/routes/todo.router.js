const express = require('express');
const ToDoModel = require('../models/todo.model');

const router = express.Router();

router.post('/todos', async (req, res) => {
  try {
    const { userId, title, description } = req.body;
    const todo = new ToDoModel({ userId, title, description });
    await todo.save();
    res.status(201).json(todo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.get('/todos/:userId', async (req, res) => {
  try {
    const todos = await ToDoModel.find({ userId: req.params.userId });
    res.json(todos);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.put('/todos/:id', async (req, res) => {
  try {
    const { title, description } = req.body;
    const todo = await ToDoModel.findByIdAndUpdate(
      req.params.id,
      { title, description },
      { new: true, runValidators: true }
    );
    if (!todo) {
      return res.status(404).json({ error: 'ToDo not found' });
    }
    res.json(todo);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.delete('/todos/:id', async (req, res) => {
  try {
    const todo = await ToDoModel.findByIdAndDelete(req.params.id);
    if (!todo) {
      return res.status(404).json({ error: 'ToDo not found' });
    }
    res.json({ message: 'ToDo deleted' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;