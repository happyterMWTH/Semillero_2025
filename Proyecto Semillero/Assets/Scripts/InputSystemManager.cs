using UnityEngine;
using UnityEngine.InputSystem; 

public class InputSystemManager : MonoBehaviour
{
    public static InputSystemManager Instance { get; private set; }

    private InputSystem_Actions playerControls;

    private Vector2 moveInput;

    public float XRaw => moveInput.x;
    public float YRaw => moveInput.y;

    public bool DashPressed { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
        
        playerControls = new InputSystem_Actions();
    }

    private void OnEnable()
    {
        playerControls.Enable();

        playerControls.Player.Move.performed += OnMove;
        playerControls.Player.Move.canceled += OnMove;

        playerControls.Player.Dash.performed += OnDash;
    }

    private void OnDisable()
    {
        playerControls.Player.Move.performed -= OnMove;
        playerControls.Player.Move.canceled -= OnMove;
        playerControls.Player.Dash.performed -= OnDash;

        playerControls.Disable();
    }

    private void OnMove(InputAction.CallbackContext ctx)
    {
        moveInput = ctx.ReadValue<Vector2>();
    }

    private void OnDash(InputAction.CallbackContext ctx)
    {
        DashPressed = true;
    }

    private void LateUpdate()
    {
        DashPressed = false;
    }
}
