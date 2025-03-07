using System.Collections;
using UnityEngine;

public class MovementTransform : MonoBehaviour
{
    [SerializeField] float moveSpeed = 3f;
    [SerializeField] float dashSpeed = 8f;
    [SerializeField] float dashDuration = 0.2f;
    [SerializeField] float dashCooldown = 1f;

    private enum DominantAxis { Horizontal, Vertical }
    [SerializeField] DominantAxis lastAxis = DominantAxis.Horizontal;

    private Vector2 movement;
    private Vector2 lastDirection = Vector2.right;
    private bool isDashing = false;
    private float lastDashTime = -Mathf.Infinity;

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
                movement = new Vector2(Mathf.Sign(x), 0f);
            }
            else if (Mathf.Abs(y) > 0.01f)
            {
                lastAxis = DominantAxis.Vertical;
                movement = new Vector2(0f, Mathf.Sign(y));
            }
        }
        else 
        {
            if (Mathf.Abs(y) > 0.01f)
            {
                movement = new Vector2(0f, Mathf.Sign(y));
            }
            else if (Mathf.Abs(x) > 0.01f)
            {
                lastAxis = DominantAxis.Horizontal;
                movement = new Vector2(Mathf.Sign(x), 0f);
            }
        }
        if (movement != Vector2.zero)
        {
            lastDirection = movement;
        }

        if (Input.GetKeyDown(KeyCode.Space) && Time.time > lastDashTime + dashCooldown)
        {
            StartCoroutine(Dash());
        }

        if (!isDashing)
        {
            transform.position += (Vector3)(movement * moveSpeed * Time.deltaTime);
        }
    }

    IEnumerator Dash()
    {
        isDashing = true;
        lastDashTime = Time.time;

        Vector2 dashDir = movement != Vector2.zero ? movement : lastDirection;
        float elapsed = 0f;

        while (elapsed < dashDuration)
        {
            transform.position += (Vector3)(dashDir * dashSpeed * Time.deltaTime);
            elapsed += Time.deltaTime;
            yield return null;
        }

        isDashing = false;
    }
}
