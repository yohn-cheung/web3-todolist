// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TodoList {
    uint256 public taskCount = 0;

    struct Task {
        uint256 id;
        string content;
        bool completed;
        uint256 timestamp; // The timestamp when the user waved.
    }

    Task[] public tasks;

    function createTask(string calldata _content) external {
        tasks.push(Task(taskCount, _content, false, block.timestamp));
        taskCount++;
    }

    function updateTask(uint256 _id, string memory _content) public {
        for (uint256 index = 0; index < tasks.length; index++) {
            if (tasks[index].id == _id) {
                tasks[index].content = _content;
                break;
            }
        }
    }

    function deleteTask(uint256 _id) external {
        for (uint256 index = 0; index < tasks.length; index++) {
            if (tasks[index].id == _id) {
                tasks[index] = tasks[tasks.length - 1];
                tasks.pop();
                break;
            }
        }
    }

    function toggleCompleted(uint256 _id) public {
        for (uint256 index = 0; index < tasks.length; index++) {
            if (tasks[index].id == _id) {
                tasks[index].completed = !tasks[index].completed;
                break;
            }
        }
    }

    function getAllTasks() external view returns (Task[] memory) {
        return tasks;
    }
}
