using Godot;

namespace Arachnomisia;

public partial class Player : CharacterBody3D
{
    [Export] private float _defaultSpeed = 5.0f;
    [Export] private float _sprintingSpeed = 10.0f;
    [Export] private float _jumpVelocity = 4.5f;
    [Export] private float _mouseSensitivity = 0.05f;

    private Node3D _head;
    private Camera3D _camera;
    private AnimationPlayer _animationPlayer;

    private float _gravity = ProjectSettings.GetSetting("physics/3d/default_gravity").AsSingle();
    private bool _sprinting = false;

    public override void _Ready()
    {
        _head = GetNode<Node3D>("Head");
        _camera = _head.GetNode<Camera3D>("Camera3D");
        _animationPlayer = _camera.GetNode<AnimationPlayer>("AnimationPlayer");

        Input.MouseMode = Input.MouseModeEnum.Captured;
    }

    public override void _PhysicsProcess(double delta)
    {
        var speed = _defaultSpeed;
        _sprinting = false;

        if (Input.IsActionPressed("sprint"))
        {
            speed = _sprintingSpeed;
            _sprinting = true;
        }

        var velocity = Velocity;

        // Add the gravity.
        if (!IsOnFloor())
        {
            velocity.Y -= _gravity * (float) delta;
        }

        // Handle Jump.
        if (Input.IsActionJustPressed("jump") && IsOnFloor())
        {
            velocity.Y = _jumpVelocity;
        }

        // Get the input direction and handle the movement/deceleration.
        var inputDir = Input.GetVector("move_left", "move_right", "move_forward", "move_backward");
        var direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
        if (direction != Vector3.Zero)
        {
            velocity.X = direction.X * speed;
            velocity.Z = direction.Z * speed;
        }
        else
        {
            velocity.X = Mathf.MoveToward(Velocity.X, 0, speed);
            velocity.Z = Mathf.MoveToward(Velocity.Z, 0, speed);
        }

        if (!velocity.IsZeroApprox() && IsOnFloor())
        {
            _animationPlayer.Play(_sprinting ? "Sprint Head Bob" : "Head Bob");
        }

        Velocity = velocity;
        MoveAndSlide();
    }

    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_cancel"))
        {
            Input.MouseMode = Input.MouseModeEnum.Visible;
        }
        else if (@event is InputEventMouseButton {ButtonIndex: MouseButton.Left} &&
                 Input.MouseMode == Input.MouseModeEnum.Visible)
        {
            Input.MouseMode = Input.MouseModeEnum.Captured;
        }
        else if (@event is InputEventMouseMotion eventMouseMotion && Input.MouseMode == Input.MouseModeEnum.Captured)
        {
            RotateY(Mathf.DegToRad(-eventMouseMotion.Relative.X * _mouseSensitivity));
            _head.RotateX(Mathf.DegToRad(-eventMouseMotion.Relative.Y * _mouseSensitivity));
            _head.Rotation = _head.Rotation with
            {
                X = Mathf.Clamp(_head.Rotation.X, Mathf.DegToRad(-89.0f), Mathf.DegToRad(89.0f))
            };
        }
    }
}