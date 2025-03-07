using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField] float moveSpeed = 3f;
    [SerializeField] float dashSpeed = 8f;
    [SerializeField] float dashDuration = 0.2f;
    [SerializeField] float dashCooldown = 1f;

    private Rigidbody2D rb;

    private enum DominantAxis { Horizontal, Vertical }
    private DominantAxis lastAxis = DominantAxis.Horizontal; 
   
    private Vector2 movement;     
    private Vector2 lastDirection = Vector2.right; 
    private bool isDashing = false;
    private float lastDashTime = -Mathf.Infinity;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
        if (isDashing) return;

        float x = Input.GetAxisRaw("Horizontal");
        float y = Input.GetAxisRaw("Vertical");

        if (Input.GetKeyDown(KeyCode.A) || Input.GetKeyDown(KeyCode.D))
            lastAxis = DominantAxis.Horizontal;

        if (Input.GetKeyDown(KeyCode.W) || Input.GetKeyDown(KeyCode.S))
            lastAxis = DominantAxis.Vertical;

        movement = Vector2.zero;
        if (lastAxis == DominantAxis.Horizontal)
        {
            if (Mathf.Abs(x) > 0.01f)
            {
                movement = new Vector2(Mathf.Sign(x), 0);
            }
            else if (Mathf.Abs(y) > 0.01f)
            {
                lastAxis = DominantAxis.Vertical;
                movement = new Vector2(0, Mathf.Sign(y));
            }
        }
        else
        {
            if (Mathf.Abs(y) > 0.01f)
            {
                movement = new Vector2(0, Mathf.Sign(y));
            }
            else if (Mathf.Abs(x) > 0.01f)
            {
                lastAxis = DominantAxis.Horizontal;
                movement = new Vector2(Mathf.Sign(x), 0);
            }
        }

        if (movement != Vector2.zero)
            lastDirection = movement;

        if (Input.GetKeyDown(KeyCode.Space) && Time.time > lastDashTime + dashCooldown)
            StartCoroutine(Dash());
    }

    void FixedUpdate()
    {
        if (!isDashing)
        {
            rb.linearVelocity = movement * moveSpeed;
        }
    }

    IEnumerator Dash()
    {
        isDashing = true;
        lastDashTime = Time.time;

        Vector2 dashDir = (movement != Vector2.zero) ? movement : lastDirection;
        rb.linearVelocity = dashDir * dashSpeed;

        yield return new WaitForSeconds(dashDuration);

        isDashing = false;
        
        if (movement == Vector2.zero)
            rb.linearVelocity = Vector2.zero;
    }
}
